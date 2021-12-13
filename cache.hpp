#ifndef _CACHE
#define _CACHE
#include <iostream>

// �Ȥꤢ������direct-mapped
#define ADDRESS_BIT 27
#define CACHE_SIZE 1024
#define BLOCK_SIZE 32
#define BLOCK_SIZE_BIT 5
#define BLOCK_NUM 32
#define BLOCK_NUM_BIT 5
// log(CACHE_SIZE) = log(BLOCK_SIZE) + log(BLOCK_NUM)
// index -> log(BLOCK_NUM_SIZE) bit
// offset -> log(BLOCKSIZE) bit
// tag -> ADRS_BIT - index - offset

// |  TAG  |  INDEX  |  OFFSET  | 
typedef struct {
    bool valid;
    // ���̥ӥåȤΤߤ����
    uint32_t tag;
    // uint32_t index;  emu->cache[ind] �� ind�Ǥ狼�롣
    uint32_t offset;
    uint32_t data[BLOCK_SIZE];
} cache_line;

typedef struct {
    uint32_t tag_mask;
    uint32_t index_mask;
    uint32_t offset_mask;
} masks;

#endif