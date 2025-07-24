void main() {
    char* video_memory = (char*) 0xb8000;  // VGA text mode memory (80x25 text mode)
    *video_memory = 'X';                   // Write 'X' to top-left corner
    *video_memory + 1 = 0x0f;             // White text on black background
}