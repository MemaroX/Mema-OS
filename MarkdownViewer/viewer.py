import markdown
import webbrowser
import os
import sys
from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

def convert_md_to_html(md_content):
    """Converts Markdown content to HTML."""
    html_content = markdown.markdown(md_content, extensions=['extra', 'codehilite'])
    return html_content

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/convert', methods=['POST'])
def convert():
    md_content = request.json.get('markdown', '')
    html_content = convert_md_to_html(md_content)
    return jsonify({'html': html_content})

@app.route('/load', methods=['POST'])
def load_file():
    file_path = request.json.get('path', '')
    if not file_path:
        return jsonify({'error': 'File path not provided.'}), 400
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        return jsonify({'content': content})
    except FileNotFoundError:
        return jsonify({'error': 'File not found.'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/save', methods=['POST'])
def save_file():
    file_path = request.json.get('path', '')
    content = request.json.get('content', '')
    if not file_path:
        return jsonify({'error': 'File path not provided.'}), 400
    try:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        return jsonify({'success': True})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True, port=8000)
