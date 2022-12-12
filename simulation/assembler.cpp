#include <iostream>
#include <fstream>
#include <string>

int main(int argc, char **argv)
{
    if(argc != 2) {
        std::cout << "Usage: assembler.exe program_file" << std::endl;
        return 0;
    }

    std::string line;
    std::ifstream file(argv[1]);

    while (getline(file, line))
    {
        std::cout << line << std::endl;
    }

    file.close();
    return 0;
}
