
/*
 * Copyright(C) 2022 Renesas Electronics Corporation
 * RENESAS ELECTRONICS CONFIDENTIAL AND PROPRIETARY.
 * This program must be used solely for the purpose for which
 * it was furnished by Renesas Electronics Corporation. No part of this
 * program may be reproduced or disclosed to others, in any
 * form, without the prior written permission of Renesas Electronics
 * Corporation.
 */
/*
 * Include Files
 *
 */
#if defined(MATLAB_MEX_FILE)
#include "tmwtypes.h"
#include "simstruc_types.h"
#else
#include "rtwtypes.h"
#endif



/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#ifdef ETVPF
#include <math.h>
#include "iodefine.h"
#include "r_cg_macrodriver.h"
#include "Test_Environment.h"
#endif
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */
/* extern double func(double a); */
/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Output functions
 *
 */
void get_TAUD_Data_Outputs_wrapper(const real_T *duty,
			const boolean_T *start_stop,
			const real_T *pulse,
			boolean_T *y0,
			const real_T *unit, const int_T p_width0,
			const real_T *TAUDid, const int_T p_width1,
			const real_T *mode, const int_T p_width2,
			const int_T y_width,
			const int_T u_width)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
#define ON 1
#define OFF 0
# ifdef ETVPF
    static int i = OFF;
    char unit_ = (char)*unit;
    char TAUDid_ = (char)*TAUDid;
    char mode_ = (char)*mode;
    
    Update_PWM_master_pulse(pulse[0]);
    if (mode_ == 0x1)
        Update_PWM_duty(duty);
    if (mode_ == 0x2)
        Update_Triangle_PWM_duty(duty);
    //Start/Stop trigger PWM
    if (start_stop[0])
    {
        if(i == OFF)
        {
            Config_TAUD_Start();
            i=ON;
        }
    }
    else
    {
        Config_TAUD_Stop();
        i=OFF;
    }
# else
    // Execute on MATLAB
    y0[0] = start_stop[0];
# endif
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}


