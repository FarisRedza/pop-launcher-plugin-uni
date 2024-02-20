import unicodedata
import json
import emoji

def generate_unicode_list():
    unicode_set = set()
    unicode_list = []

    # Process emojis using the emoji library
    for emoji_char, emoji_data in emoji.EMOJI_DATA.items():
        emoji_name = emoji_data.get('en', '').strip(':').replace('_', ' ').lower()  # Replace underscores with spaces
        if emoji_name not in unicode_set:
            unicode_set.add(emoji_name)
            unicode_list.append({'character': emoji_char, 'description': emoji_name})

    # Process standard Unicode characters
    for code_point in range(0x110000):  # Unicode range
        char = chr(code_point)
        try:
            description = unicodedata.name(char).lower()
            if description not in unicode_set and description.replace(' face', '') not in unicode_set:
                unicode_set.add(description)
                unicode_list.append({'character': char, 'description': description})
        except ValueError:
            # Some code points don't have a description, so we skip them
            pass

    return unicode_list

# Generate the list of Unicode characters and names
unicode_data_list = generate_unicode_list()

# Write the list to a file in JSON format
output_file_path = 'src/characters.json'
with open(output_file_path, 'w', encoding='utf-8') as f:
    json.dump(unicode_data_list, f, ensure_ascii=False, indent=2)