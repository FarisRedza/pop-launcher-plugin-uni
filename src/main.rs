use std::io::{self, BufRead};

use pop_launcher::*;
use copypasta::ClipboardProvider;

#[derive(serde::Serialize, serde::Deserialize, Clone)]
struct Character {
    character: String,
    description: String,
}

struct App {
    characters: Vec<Character>,
    matches: Option<Vec<String>>,
    descriptions: Option<Vec<String>>
}

impl App {
    fn new() -> Self {
        let characters: Vec<Character> = Self::load_characters();
        App {
            characters,
            matches: None,
            descriptions: None
        }
    }

    fn load_characters() -> Vec<Character> {
        let mut characters_file_path: std::path::PathBuf = std::env::current_exe()
            .expect("Failed to get exe directory");
        
        characters_file_path.pop();
        
        characters_file_path.push("characters.json");
        
        let file_content = std::fs::read_to_string(characters_file_path)
            .expect("Failed to read characters.json");

        match serde_json::from_str(&file_content) {
            Ok(characters) => characters,
            Err(_) => {
                panic!("Failed to deserialize JSON");
            }
        }
    }

    fn search_character(&mut self, query: &str) {
        let mut scored_descriptions: Vec<(f64, &Character)> = self
            .characters
            .iter()
            .map(|character| {
                let score = strsim::jaro_winkler(&character.description, query);
                (score, character)
            })
            .collect();

        scored_descriptions.sort_by(|a, b| b.0.partial_cmp(&a.0).unwrap());

        let top_matches: Vec<&(f64, &Character)> = scored_descriptions
            .iter()
            .take(8)
            .collect::<Vec<_>>();

        self.matches = Some(top_matches.iter().map(|(_, char)| char.character.clone()).collect());
        self.descriptions = Some(top_matches.iter().map(|(_, char)| char.description.clone()).collect());
    }
    
    fn activate(&self, index: usize) {
        if let Some(matches) = &self.matches {
            if !matches.is_empty() {
                let mut ctx: copypasta::x11_clipboard::X11ClipboardContext = copypasta::ClipboardContext::new()
                    .unwrap();
                let selection: &String = &matches[index];
                ctx.set_contents(selection.to_owned())
                    .unwrap();
                let _content: String = ctx
                    .get_contents()
                    .unwrap();

                println!("\"Close\"");
            }
        }
    }

    fn search(&mut self, query: &str) {
        let query: String = query
            .split_whitespace()
            .skip(1)
            .collect::<Vec<&str>>()
            .join(" ");

        self.search_character(&query);


        if let (Some(matches), Some(descriptions)) = (&self.matches, &self.descriptions) {
            for (index, word) in matches.iter().enumerate() {
                let response: PluginResponse = PluginResponse::Append( PluginSearchResult {
                    id: index as u32,
                    name: word.to_string(),
                    description: format!("{}", descriptions[index]),
                    ..Default::default()
                });
                println!("{}", serde_json::to_string(&response).unwrap());
            }
        }
        println!("\"Finished\"");
    }
}

fn main() {
    let mut app: App = App::new();
    let stdin: io::Stdin = io::stdin();

    for line in stdin.lock().lines() {
        let line: String = match line {
            Ok(line) => line,
            Err(_) => continue,
        };

        let request: serde_json::Value = serde_json::from_str(&line).unwrap_or(serde_json::Value::Null);

        if let Some(query) = request.get("Search").and_then(|v| v.as_str()) {
            app.search(query);
            continue;
        }

        if let Some(index) = request.get("Activate").and_then(|v| v.as_u64()) {
            app.activate(index as usize);
        }
    }
}