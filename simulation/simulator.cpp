#include <iostream>
#include <stdint.h>

// Memory
uint8_t MEM[256];
uint8_t REG_FILE[8];
uint8_t REG_A;
uint8_t REG_B;

// Control
uint8_t PC;
uint8_t IR;
uint8_t MAR;
uint8_t BUS;
uint8_t FLAG; // OPNZ
uint16_t CONTROL_WORD;
uint16_t CONTROL_STORE[32] = {

};

#define ALU_EN 0
#define ALU_OP0 1
#define ALU_OP1 2
#define MAR_EN 3
#define MAR_LD 4
#define REG_A_EN 5
#define REG_A_LD 6
#define REG_B_EN 7
#define REG_B_LD 8
#define IR_EN 9
#define IR_LD 10
#define PC_JMP 11
#define PC_LD 12

uint8_t readBit(uint16_t bin, uint8_t index)
{
    return (bin & 1 << index) ? 1 : 0;
}

int main()
{

    std::cout << "Simulation started" << std::endl;

    // IR = MEM[PC];
    // CONTROL_WORD = CONTROL_STORE[IR];

    // Addition
    // CONTROL_WORD = 0x0001;
    // REG_A = 125;
    // REG_B = 3;

    // Substraction
    // CONTROL_WORD = 0x0003;
    // REG_A = 3;
    // REG_B = 2;

    // AND logic
    // CONTROL_WORD = 0x0005;
    // REG_A = 4;
    // REG_B = 5;

    // NOT logic
    // CONTROL_WORD = 0x0007;
    // REG_A = 4;

    if (readBit(CONTROL_WORD, ALU_EN))
    {
        uint8_t OP = readBit(CONTROL_WORD, ALU_OP1) << 1 | readBit(CONTROL_WORD, ALU_OP0);
        bool OV = false;

        switch (OP)
        {
        // ADD operation
        case 0b00:
            BUS = REG_A + REG_B;
            if (readBit(REG_A, 7) == readBit(REG_B, 7) && readBit(BUS, 7) != readBit(REG_A, 7))
            {
                OV = true;
            }
            break;

        // SUB operation
        case 0b01:
            BUS = REG_A - REG_B;
            if (readBit(REG_A, 7) == readBit(REG_B, 7) && readBit(BUS, 7) != readBit(REG_A, 7))
            {
                OV = true;
            }
            break;

        // AND operation
        case 0b10:
            BUS = REG_A & REG_B;
            break;

        // NOT operation
        case 0b11:
            std::cout << "Flag" << std::endl;
            BUS = ~REG_A;
            break;

        default:
            std::cout << "Operation not implemented: " << OP << std::endl;
        }

        // Set condition flags for branch instructions
        FLAG |= (OV) ? (1 << 3) : (0 << 3);
        if (FLAG == 0)
        {
            FLAG |= (BUS == 0) ? (1 << 0) : (0 << 0);
            FLAG |= (BUS < 0) ? (1 << 1) : (0 << 1);
            FLAG |= (BUS > 0) ? (1 << 2) : (0 << 2);
        }
    }

    // std::cout << (int)BUS << std::endl;
    // std::cout << (int)FLAG << std::endl;

    if (readBit(CONTROL_WORD, MAR_EN))
    {
        MAR = BUS;

        // Write to memory
        if (readBit(CONTROL_WORD, MAR_LD))
        {
            MEM[MAR] = BUS;
        }
        // Read from memory
        else
        {
            BUS = MEM[MAR];
        }
    }

    if (readBit(CONTROL_WORD, REG_A_EN) || readBit(CONTROL_WORD, REG_B_EN))
    {
        // Register A
        if (readBit(CONTROL_WORD, REG_A_LD))
        {
            REG_A = BUS;
        }
        else
        {
            BUS = REG_A;
        }

        // Register B
        if (readBit(CONTROL_WORD, REG_B_LD))
        {
            REG_B = BUS;
        }
        else
        {
            BUS = REG_B;
        }
    }

    if (readBit(CONTROL_WORD, IR_EN))
    {
        if (readBit(CONTROL_WORD, IR_LD))
        {
            IR = BUS;
        }
        else
        {
            BUS = IR;
        }
    }

    if (readBit(CONTROL_WORD, PC_JMP))
    {
        if (readBit(CONTROL_WORD, PC_LD))
        {
            PC = BUS;
        }
    }

    std::cout << "Simulation ended" << std::endl;
    return 0;
}