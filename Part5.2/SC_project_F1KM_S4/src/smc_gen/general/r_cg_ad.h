/***********************************************************************************************************************
* DISCLAIMER
* This software is supplied by Renesas Electronics Corporation and is only intended for use with Renesas products.
* No other uses are authorized. This software is owned by Renesas Electronics Corporation and is protected under all
* applicable laws, including copyright laws. 
* THIS SOFTWARE IS PROVIDED "AS IS" AND RENESAS MAKES NO WARRANTIES REGARDING THIS SOFTWARE, WHETHER EXPRESS, IMPLIED
* OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NON-INFRINGEMENT.  ALL SUCH WARRANTIES ARE EXPRESSLY DISCLAIMED.TO THE MAXIMUM EXTENT PERMITTED NOT PROHIBITED BY
* LAW, NEITHER RENESAS ELECTRONICS CORPORATION NOR ANY OF ITS AFFILIATED COMPANIES SHALL BE LIABLE FOR ANY DIRECT,
* INDIRECT, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES FOR ANY REASON RELATED TO THIS SOFTWARE, EVEN IF RENESAS OR
* ITS AFFILIATES HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
* Renesas reserves the right, without notice, to make changes to this software and to discontinue the availability 
* of this software. By using this software, you agree to the additional terms and conditions found by accessing the 
* following link:
* http://www.renesas.com/disclaimer
*
* Copyright (C) 2019 Renesas Electronics Corporation. All rights reserved.
***********************************************************************************************************************/

/***********************************************************************************************************************
* File Name    : r_cg_ad.h
* Version      : 1.0.101
* Device(s)    : R7F701650
* Description  : General header file for ADCA peripheral.
***********************************************************************************************************************/

#ifndef ADCA_H
#define ADCA_H

/***********************************************************************************************************************
Macro definitions (Register bit)
***********************************************************************************************************************/
#define _ADC0_VCHANNEL_DATA_BASE                  (0xFFF20100UL)
#define _ADC1_VCHANNEL_DATA_BASE                  (0xFFD6D100UL)
/*
    Virtual channel control register (ADCAnVCRm)
*/
/* A/D Conversion End Interrupt Enable. (ADIE) */
#define _ADC_VIRTUAL_CHANNEL_END_INT_DISABLE      (0x00000000UL) /* not generated */
#define _ADC_VIRTUAL_CHANNEL_END_INT_ENABLE       (0x00000100UL) /* generated */
/* Upper limit/lower limit table select (ULS[3-0]) */
#define _ADC_LIMIT_TABLE_SELECT_NONE              (0x00000000UL) /* Upper limit and lower limit are not checked. */
#define _ADC_LIMIT_TABLE_SELECT_0                 (0x00000040UL) /* Upper limit and lower limit are checked for ULLMTBR0. */
#define _ADC_LIMIT_TABLE_SELECT_1                 (0x00000080UL) /* Upper limit and lower limit are checked for ULLMTBR1. */
#define _ADC_LIMIT_TABLE_SELECT_2                 (0x000000C0UL) /* Upper limit and lower limit are checked for ULLMTBR2. */
#define _ADC_LIMIT_TABLE_SELECT_3                 (0x00000400UL) /* Upper limit and lower limit are checked for ULLMTBR3. */
#define _ADC_LIMIT_TABLE_SELECT_4                 (0x00000440UL) /* Upper limit and lower limit are checked for ULLMTBR4. */
#define _ADC_LIMIT_TABLE_SELECT_5                 (0x00000480UL) /* Upper limit and lower limit are checked for ULLMTBR5. */
#define _ADC_LIMIT_TABLE_SELECT_6                 (0x000004C0UL) /* Upper limit and lower limit are checked for ULLMTBR6. */
#define _ADC_LIMIT_TABLE_SELECT_7                 (0x00000800UL) /* Upper limit and lower limit are checked for ULLMTBR7. */
/* A/D conversion general control (GCTRL[5-0]) */
#define _ADC_PHYSICAL_CHANNEL_AN00                (0x00000000UL) /* AN00 */
#define _ADC_PHYSICAL_CHANNEL_AN01                (0x00000001UL) /* AN01 */
#define _ADC_PHYSICAL_CHANNEL_AN02                (0x00000002UL) /* AN02 */
#define _ADC_PHYSICAL_CHANNEL_AN03                (0x00000003UL) /* AN03 */
#define _ADC_PHYSICAL_CHANNEL_AN04                (0x00000004UL) /* AN04 */
#define _ADC_PHYSICAL_CHANNEL_AN05                (0x00000005UL) /* AN05 */
#define _ADC_PHYSICAL_CHANNEL_AN06                (0x00000006UL) /* AN06 */
#define _ADC_PHYSICAL_CHANNEL_AN07                (0x00000007UL) /* AN07 */
#define _ADC_PHYSICAL_CHANNEL_AN08                (0x00000008UL) /* AN08 */
#define _ADC_PHYSICAL_CHANNEL_AN09                (0x00000009UL) /* AN09 */
#define _ADC_PHYSICAL_CHANNEL_AN10                (0x0000000AUL) /* AN10 */
#define _ADC_PHYSICAL_CHANNEL_AN11                (0x0000000BUL) /* AN11 */
#define _ADC_PHYSICAL_CHANNEL_AN12                (0x0000000CUL) /* AN12 */
#define _ADC_PHYSICAL_CHANNEL_AN13                (0x0000000DUL) /* AN13 */
#define _ADC_PHYSICAL_CHANNEL_AN14                (0x0000000EUL) /* AN14 */
#define _ADC_PHYSICAL_CHANNEL_AN15                (0x0000000FUL) /* AN15 */
#define _ADC_PHYSICAL_CHANNEL_AN16                (0x00000010UL) /* AN16 */
#define _ADC_PHYSICAL_CHANNEL_AN17                (0x00000011UL) /* AN17 */
#define _ADC_PHYSICAL_CHANNEL_AN18                (0x00000012UL) /* AN18 */
#define _ADC_PHYSICAL_CHANNEL_AN19                (0x00000013UL) /* AN19 */
#define _ADC_PHYSICAL_CHANNEL_AN20                (0x00000014UL) /* AN20 */
#define _ADC_PHYSICAL_CHANNEL_AN21                (0x00000015UL) /* AN21 */
#define _ADC_PHYSICAL_CHANNEL_AN22                (0x00000016UL) /* AN22 */
#define _ADC_PHYSICAL_CHANNEL_AN23                (0x00000017UL) /* AN23 */
#define _ADC_PHYSICAL_CHANNEL_AN24                (0x00000018UL) /* AN24 */
#define _ADC_PHYSICAL_CHANNEL_AN25                (0x00000019UL) /* AN25 */
#define _ADC_PHYSICAL_CHANNEL_AN26                (0x0000001AUL) /* AN26 */
#define _ADC_PHYSICAL_CHANNEL_AN27                (0x0000001BUL) /* AN27 */
#define _ADC_PHYSICAL_CHANNEL_AN28                (0x0000001CUL) /* AN28 */
#define _ADC_PHYSICAL_CHANNEL_AN29                (0x0000001DUL) /* AN29 */
#define _ADC_PHYSICAL_CHANNEL_AN30                (0x0000001EUL) /* AN30 */
#define _ADC_PHYSICAL_CHANNEL_AN31                (0x0000001FUL) /* AN31 */
#define _ADC_PHYSICAL_CHANNEL_AN32                (0x00000020UL) /* AN32 */
#define _ADC_PHYSICAL_CHANNEL_AN33                (0x00000021UL) /* AN33 */
#define _ADC_PHYSICAL_CHANNEL_AN34                (0x00000022UL) /* AN34 */
#define _ADC_PHYSICAL_CHANNEL_AN35                (0x00000023UL) /* AN35 */

/*
    A/D force halt register (ADCAnADHALTR)
*/
/* A/D force halt register (HALT) */
#define _ADC_HALT                                 (0x00000001UL) /* Scan groups are halted */

/*
    A/D control register (ADCAnADCR)
*/
/* 12/10 Bit Select Mode (CTYP) */
#define _ADC_12_BIT_MODE                          (0x00000000UL) /* 12-bit mode */
#define _ADC_10_BIT_MODE                          (0x00000010UL) /* 10-bit mode */

/*
    TH sampling start control register (ADCAnTHSMPSTCR)
*/
/* TH sampling start control trigger (SMPST) */
#define _ADC_TH_SAMPLING_ALL_START                (0x00000001UL) /* Sampling for all TH is started */

/*
    TH control register (ADCAnTHCR)
*/
/* Automatic sampling mask control (ASMPMSK) */
#define _ADC_TH_SAMPLING_MANUAL                   (0x00000000UL) /* Automatic sampling is not performed */
#define _ADC_TH_SAMPLING_AUTOMATIC                (0x00000001UL) /* Automatic sampling is performed */

/*
    TH group A/B control register (ADCAnTHABCR)
*/
/* TH group A/B hold trigger enable (HLDTE) */
#define _ADC_TH_SG_START_TRIGGER_USED             (0x00000000UL) /* trigger is selected for the hold start trigger of TH group A/B */
#define _ADC_TH_SG_START_TRIGGER_UNUSED           (0x00000010UL) /* trigger is not selected for the hold start trigger of TH group A/B */
/* TH group A/B scan group select (SGS[1-0]) */
#define _ADC_TH_SELECT_NONE                       (0x00000000UL) /* No scan group is selected for TH group A/B */
#define _ADC_TH_SELECT_SG1                        (0x00000001UL) /* SG1 is selected for TH group A/B */
#define _ADC_TH_SELECT_SG2                        (0x00000002UL) /* SG2 is selected for TH group A/B */
#define _ADC_TH_SELECT_SG3                        (0x00000003UL) /* SG3 is selected for TH group A/B */

/*
    TH enable register (ADCAnTHER)
*/
/* TH5 Enable (TH5E) */
#define _ADC_TH5_DISABLED                         (0x00000000UL) /* TH5 is disabled */
#define _ADC_TH5_ENABLED                          (0x00000020UL) /* TH5 is enabled */
/* TH4 Enable (TH4E) */
#define _ADC_TH4_DISABLED                         (0x00000000UL) /* TH4 is disabled */
#define _ADC_TH4_ENABLED                          (0x00000010UL) /* TH4 is enabled */
/* TH3 Enable (TH3E) */
#define _ADC_TH3_DISABLED                         (0x00000000UL) /* TH3 is disabled */
#define _ADC_TH3_ENABLED                          (0x00000008UL) /* TH3 is enabled */
/* TH2 Enable (TH2E) */
#define _ADC_TH2_DISABLED                         (0x00000000UL) /* TH2 is disabled */
#define _ADC_TH2_ENABLED                          (0x00000004UL) /* TH2 is enabled */
/* TH1 Enable (TH1E) */
#define _ADC_TH1_DISABLED                         (0x00000000UL) /* TH1 is disabled */
#define _ADC_TH1_ENABLED                          (0x00000002UL) /* TH1 is enabled */
/* TH0 Enable (TH0E) */
#define _ADC_TH0_DISABLED                         (0x00000000UL) /* TH0 is disabled */
#define _ADC_TH0_ENABLED                          (0x00000001UL) /* TH0 is enabled */

/*
    TH group select register (ADCAnTHGSR)
*/
/* TH5 group select (TH5GS) */
#define _ADC_TH5_GROUP_A                          (0x00000000UL) /* TH5 is selected to group A */
#define _ADC_TH5_GROUP_B                          (0x00000020UL) /* TH5 is selected to group B */
/* TH4 group select (TH4GS) */
#define _ADC_TH4_GROUP_A                          (0x00000000UL) /* TH4 is selected to group A */
#define _ADC_TH4_GROUP_B                          (0x00000010UL) /* TH4 is selected to group B */
/* TH3 group select (TH3GS) */
#define _ADC_TH3_GROUP_A                          (0x00000000UL) /* TH3 is selected to group A */
#define _ADC_TH3_GROUP_B                          (0x00000008UL) /* TH3 is selected to group B */
/* TH2 group select (TH2GS) */
#define _ADC_TH2_GROUP_A                          (0x00000000UL) /* TH2 is selected to group A */
#define _ADC_TH2_GROUP_B                          (0x00000004UL) /* TH2 is selected to group B */
/* TH1 group select (TH1GS) */
#define _ADC_TH1_GROUP_A                          (0x00000000UL) /* TH1 is selected to group A */
#define _ADC_TH1_GROUP_B                          (0x00000002UL) /* TH1 is selected to group B */
/* TH0 group select (TH0GS) */
#define _ADC_TH0_GROUP_A                          (0x00000000UL) /* TH0 is selected to group A */
#define _ADC_TH0_GROUP_B                          (0x00000001UL) /* TH0 is selected to group B */

/*
    Sampling control register (ADCAnSMPCR)
*/
/* These bits are used to set the sampling time (the number of cycles) (SMPT[7-0]) */
#define _ADC_18_CYCLES                            (0x00000012UL) /* 18 cycles (PCLK = 8 MHz to 32 MHz) */
#define _ADC_24_CYCLES                            (0x00000018UL) /* 24 cycles (PCLK = 8 MHz to 40 MHz) */

/*
    Safety control register (ADCAnSFTCR)
*/
/* Read and clear enable (RDCLRE) */
#define _ADC_READ_CLEAR_DISABLED                  (0x00000000UL) /* The A/D conversion result is not cleared by hardware */
#define _ADC_READ_CLEAR_ENABLED                   (0x00000010UL) /* The A/D conversion result is cleared by hardware */
/* A/D Error Interrupt (INT_ADE) Enable on Upper/Lower Limit Error Detection (ULEIE) */
#define _ADC_LIMIT_ERROR_INT_DISABLE              (0x00000000UL) /* Disabled */
#define _ADC_LIMIT_ERROR_INT_ENABLE               (0x00000008UL) /* Enabled */
/* A/D Error Interrupt (INT_ADE) Enable on Overwrite Error Detection (OWEIE) */
#define _ADC_OVERWRITE_ERROR_INT_DISABLE          (0x00000000UL) /* Disabled */
#define _ADC_OVERWRITE_ERROR_INT_ENABLE           (0x00000004UL) /* Enabled */

/*
    Scan group 1 start control register (ADCAnSGSTCRm)
*/
/* Scan group start trigger (SGST) */
#define _ADC_START                                (0x00000001UL) /* Starts the target SG */

/*
    Scan group 1 control register (ADCAnSGCRm)
*/
/* Scan mode (SCANMD) */
#define _ADC_SG_SCAN_MODE_MULTICYCLE              (0x00000000UL) /* Multicycle scan mode */
#define _ADC_SG_SCAN_MODE_CONTINUOUS              (0x00000020UL) /* Continuous scan mode */
/* Scan end interrupt enable (ADIE) */
#define _ADC_SG_SCAN_END_INT_DISABLE              (0x00000000UL) /* INT_SG1 is not output */
#define _ADC_SG_SCAN_END_INT_ENABLE               (0x00000010UL) /* INT_SG1 is output */
/* Trigger mode (TRGMD) */
#define _ADC_SG_HW_TRIGGER_DISABLE                (0x00000000UL) /* Trigger input is disabled */
#define _ADC_SG_HW_TRIGGER_ENABLE                 (0x00000001UL) /* Start trigger or hold complete trigger selected for the trigger input */

/*
    Scan Group 1 Multicycle Register (ADCAnSGMCYCRm)
*/
/* Multicycle number specification (MCYC[1-0]) */
#define _ADC_SG_MULTICYCLE_NUMBER_1               (0x00000000UL) /* Number of scans = 1 */
#define _ADC_SG_MULTICYCLE_NUMBER_2               (0x00000001UL) /* Number of scans = 2 */
#define _ADC_SG_MULTICYCLE_NUMBER_4               (0x00000003UL) /* Number of scans = 4 */

/*
    A/D force halt register (ADCAnSGTSELm)
*/
/* A/D conversion hardware trigger select (T1SEL9) */
#define _ADC_SG_HW_TRIGGER_FACTOR_9               (0x00000200UL) /* Hardware trigger factor 9 enabled */
/* A/D conversion hardware trigger select (T1SEL8) */
#define _ADC_SG_HW_TRIGGER_FACTOR_8               (0x00000100UL) /* Hardware trigger factor 8 enabled  */
/* A/D conversion hardware trigger select (T1SEL7) */
#define _ADC_SG_HW_TRIGGER_FACTOR_7               (0x00000080UL) /* Hardware trigger factor 7 enabled  */
/* A/D conversion hardware trigger select (T1SEL6) */
#define _ADC_SG_HW_TRIGGER_FACTOR_6               (0x00000040UL) /* Hardware trigger factor 6 enabled  */
/* A/D conversion hardware trigger select (T1SEL5) */
#define _ADC_SG_HW_TRIGGER_FACTOR_5               (0x00000020UL) /* Hardware trigger factor 5 enabled  */
/* A/D conversion hardware trigger select (T1SEL4) */
#define _ADC_SG_HW_TRIGGER_FACTOR_4               (0x00000010UL) /* Hardware trigger factor 4 enabled  */
/* A/D conversion hardware trigger select (T1SEL3) */
#define _ADC_SG_HW_TRIGGER_FACTOR_3               (0x00000008UL) /* Hardware trigger factor 3 enabled  */
/* A/D conversion hardware trigger select (T1SEL2) */
#define _ADC_SG_HW_TRIGGER_FACTOR_2               (0x00000004UL) /* Hardware trigger factor 2 enabled  */
/* A/D conversion hardware trigger select (T1SEL1) */
#define _ADC_SG_HW_TRIGGER_FACTOR_1               (0x00000002UL) /* Hardware trigger factor 1 enabled  */
/* A/D conversion hardware trigger select (T1SEL0) */
#define _ADC_SG_HW_TRIGGER_EXTERNAL_PIN           (0x00000001UL) /* External trigger pin enabled */

/***********************************************************************************************************************
Macro definitions
***********************************************************************************************************************/

/***********************************************************************************************************************
Typedef definitions
***********************************************************************************************************************/

/***********************************************************************************************************************
Global functions
***********************************************************************************************************************/
/* Start user code for function. Do not edit comment generated here */
/* End user code. Do not edit comment generated here */
#endif
