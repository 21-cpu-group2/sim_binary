#ifndef _CACHE
#define _CACHE
#include <iostream>
#include "simulator.hpp"

// とりあえず、direct-mapped
#define ADDRESS_BIT 27
#define CACHE_SIZE 1024

#define CACHE_LINE_NUM 2048
#define CACHE_LINE_SIZE 2 // 4 words

#define TAG_BIT 13
#define TAG_MASK 0x07FFC0000

#define INDEX_BIT 11
#define INDEX_MASK 0x00003FF0 

#define OFFSET_BIT 3
#define OFFSET_MASK 0x0000000F

// lw hit→キャッシュから読んで返すだけ
// lw miss→メモリから1ライン読んでキャッシュに載せる。必要なデータを返す
// sw hit→キャッシュにも書き込んで、メモリにも書く
// sw miss→メモリからデータを持ってきて、それを元にキャッシュへの書き込みをする+メモリにも書き込む

// |  TAG  |  INDEX  |  OFFSET  | 


typedef struct {
    uint32_t tag_mask;
    uint32_t index_mask;
    uint32_t offset_mask;
} masks;

#endif