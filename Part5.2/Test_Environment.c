/*
 * Copyright(C) 2022 Renesas Electronics Corporation
 * RENESAS ELECTRONICS CONFIDENTIAL AND PROPRIETARY.
 * This program must be used solely for the purpose for which
 * it was furnished by Renesas Electronics Corporation. No part of this
 * program may be reproduced or disclosed to others, in any
 * form, without the prior written permission of Renesas Electronics
 * Corporation.
 *
 */
 
// ET-VPF F1KM Product Version - V1.00.00 - Req. 01
// ID: ET_VPF_V1.00.00_CD_Req_01_013
// Reference: {ET_VPF_V1.00.00_UD_Req_01_001, ET_VPF_V1.00.00_UD_Req_01_002, ET_VPF_V1.00.00_UD_Req_01_004}

/* Include Section */
#include "Test_Environment.h"

/* Define */
#define INT_TABLE_REF_FLAG  0x0040
#define ECMM_BASE           0xFFCB0000
#define ECM_BASE            0xFFCB2000
#define ECMmESSTRn(n)       *((volatile unsigned long *)(ECMM_BASE + 0x08 + 4*n))
#define ECMESSTCn(n)        *((volatile unsigned long *)(ECM_BASE  + 0xA4 + 4*n))
#define TEST_PASSED         1
#define TEST_FAILED         0
#define AES_MAX_DATA_POINTS 200

#define DISABLE_WRITE_KEY_CODE  (0xA5A5A500UL)
#define ENABLE_WRITE_KEY_CODE   (0xA5A5A501UL)
#define GPT_EIC_BASE_ADDR       (0xFFF80000UL)
#define GPT_EIC_ADDR(n)         ((GPT_EIC_BASE_ADDR) + ((n) * 2UL))

/* Global variables */
// ET-VPF F1KM Product Version - V1.00.00 - Req. 04
// ID: ET_VPF_V1.00.00_CD_Req_04_026
// Reference: {ET_VPF_V1.00.00_UD_Req_04_001, ET_VPF_V1.00.00_UD_Req_04_002, ET_VPF_V1.00.00_UD_Req_04_004, ET_VPF_V1.00.00_UD_Req_04_005, ET_VPF_V1.00.00_UD_Req_04_006, ET_VPF_V1.00.00_UD_Req_04_007}
// The unit array of all RLIN3n using UART transmission/ UART reception function
unsigned int GMemForSetPortRxControl1 = 0;
volatile struct __tag443 * RLIN3n_reg;
volatile struct __tag443 * arr_RLIN3n[4] = {&RLN30, &RLN31, &RLN32, &RLN33};
// ET-VPF F1KM Product Version - V1.00.00 - Req. 04 - End
unsigned char GaaTestResult [AES_MAX_DATA_POINTS] = {0};
unsigned char GucCurrentTestPoint = 0;

/* Function definition */
void Mcu_Init(void)
{
    /* Interrupt settings */
    /* Set Reference Table Method */
    INTC2.ICOSTM0.BIT.TBOSTM0 = 0x1;

    /* Disable interrupt mask */
    INTC2.ICOSTM0.BIT.MKOSTM0 = 0x0;

    EI();
}

// OSTM for synchronizing
void R_OSTM0_Create(void)
{
    /* Disable OSTM0 operation */
    OSTM0.TT = _OSTM_COUNTER_STOP;

    /* Set OSTM0 control setting */
    OSTM0.CTL = _INTERVAL_TIME_START;// Using interval time
    
    // Set the duration
    OSTM0.CMP = (SAMPLING_TIME_MS*1.0/1000)*PCLK;
}

void R_OSTM0_Start(void)
{
    /* Clear OSTM0 interrupt request and enable operation */
    
    /* Enable OSTM0 operation */
    OSTM0.TS = _OSTM_COUNTER_START;
}

/*Set_port_value s-function*/
void Set_port_value(boolean_T *u0, unsigned char port, unsigned char pin)
{
    short portValue = (short) *u0;
    Pn(port) = (Pn(port) & (~(1 << pin))) | (portValue << pin);
}

/* Get value from in-port */
void Get_port_value(boolean_T *y0, unsigned char port, unsigned char pin)
{
    short portValue;
    portValue = ((PPRn(port) >> pin) & 0x1); // move the target bit of pin to the last bit. Then get the value by using mask 0x1
    *y0 = (unsigned char) portValue;
}
// ET-VPF F1KM Product Version - V1.00.00 - Req. 03
// ID: ET_VPF_V1.00.00_CD_Req_03_016
// Reference: {ET_VPF_V1.00.00_UD_Req_03_001, ET_VPF_V1.00.00_UD_Req_03_002, ET_VPF_V1.00.00_UD_Req_03_003 ,ET_VPF_V1.00.00_UD_Req_03_004, ET_VPF_V1.00.00_UD_Req_03_007} 
double calculate_clock_scale(int taud_tps)
{
    int CK0 = taud_tps & 0xF;
    int CK1 = (taud_tps >> 4) & 0xF;
    int CK2 = (taud_tps >> 8) & 0xF;
    int CK3 = (taud_tps >> 12);
    int select_scale = 0;
    int result = 0;
    if(CK0 != 0xF)
        select_scale = CK0;
    else if(CK1 != 0xF)
        select_scale = CK1;
    else if(CK2 != 0xF)
        select_scale = CK2;
    else if(CK3 != 0xF)
        select_scale = CK3;
    else
        return result = pow(2,15);

    switch (select_scale)
    {
    case 0x0:
        result = pow(2,0);
        break;
    case 0x1:
        result = pow(2,1);
        break;    
    case 0x2:
        result = pow(2,2);
        break;
    case 0x3:
        result = pow(2,3);
        break;   
    case 0x4:
        result = pow(2,4);
        break;
    case 0x5:
        result = pow(2,5);
        break;              
    case 0x6:
        result = pow(2,6);
        break;  
    case 0x7:
        result = pow(2,7);
        break;  
    case 0x8:
        result = pow(2,8);
        break;  
    case 0x9:
        result = pow(2,9);
        break;    
    case 0xa:
        result = pow(2,10);
        break;   
    case 0xb:
        result = pow(2,11);
        break;    
    case 0xc:
        result = pow(2,12);
        break;                                                                   
    case 0xd:
        result = pow(2,13);
        break;            
    case 0xe:
        result = pow(2,14);
        break;            
    default:
        break;
    }
    return result;
}

/* End of file */
// ET-VPF F1KM Product Version - V1.00.00 - Req. 01 - End
// ET-VPF F1KM Product Version - V1.00.00 - Req. 03 - End