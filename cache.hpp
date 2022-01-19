#ifndef _CACHE
#define _CACHE
#include <iostream>
#include "simulator.hpp"

// �Ȥꤢ������direct-mapped
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

// lw hit������å��夫���ɤ���֤�����
// lw miss�����꤫��1�饤���ɤ�ǥ���å���˺ܤ��롣ɬ�פʥǡ������֤�
// sw hit������å���ˤ�񤭹���ǡ�����ˤ��
// sw miss�����꤫��ǡ�������äƤ��ơ�����򸵤˥���å���ؤν񤭹��ߤ򤹤�+����ˤ�񤭹���

// |  TAG  |  INDEX  |  OFFSET  | 


typedef struct {
    uint32_t tag_mask;
    uint32_t index_mask;
    uint32_t offset_mask;
} masks;

#endif