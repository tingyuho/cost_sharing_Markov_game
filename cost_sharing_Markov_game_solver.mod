/*********************************************
 * OPL 12.6.0.0 Model
 * Author: user
 * Creation Date: Oct 15, 2015 at 10:28:57 AM
 *********************************************/
// --------------------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// 5725-A06 5725-A29 5724-Y48 5724-Y49 5724-Y54 5724-Y55
// Copyright IBM Corporation 1998, 2013. All Rights Reserved.
//
// Note to U.S. Government Users Restricted Rights:
// Use, duplication or disclosure restricted by GSA ADP Schedule
// Contract with IBM Corp.
// --------------------------------------------------------------------------

//number
int NbStates = ...; 
int NbAction_L = ...;
int NbAction_F = ...; 
int NbDiscreteP= ...; //number of discrite probability for the leader

//set
range State = 1..NbStates; 
range Action_L = 1..NbAction_L; 
range Action_F = 1..NbAction_F; 
range P_K = 1..NbDiscreteP; 

//parameter
float CostTreatment [State][Action_F] = ...; // cost of different treatments or drugs
float BenefitFormulary [Action_L][Action_F] = ...; // heathcare insurance policy
float Probability [P_K] = ...;  
float Beta [State] = ...;
float Gamma_L = ...; // discount rate for the leader
float Gamma_F = ...; // discount rate for the follower

//float PmtAction_F [State][Action_F] = ...;
//float PmtHealth_L [State][Action_F] = ...;
//float PmtHealth_F [State] = ...;
float R_L [State][Action_L][Action_F] = ...; //R_L [s, al, af] == -(1-BenefitFormulary[al,af])*CostTreatment[af]+PmtHealth_L[s];
float R_F [State][Action_L][Action_F] = ...; //R_F [s, al, af] == -BenefitFormulary[al,af]*CostTreatment[af]+PmtHealth_F[s]+(PmtAction_F[af])^2; 
float T [Action_F][State][State] = ...; //transition probability
float Z = ...;  			

//devision variables
dvar boolean 	phi [State][Action_F]; 
dvar float	 	V_L [State];
dvar float	 	V_F [State];
dvar float	 	z [State][Action_L][Action_F][P_K];
dvar float  	w [State][Action_L][Action_F][P_K];
dvar boolean 	d [State][Action_L][P_K];


maximize 
  sum(s in State) Beta[s]*(V_L[s]);
subject to {
  forall( s in State, al in Action_L )
    ct1:
      	sum( k in P_K ) d[s,al,k] == 1;
  forall( s in State )
    ct2:
      	sum(al in Action_L,  k in P_K) Probability[k]*d[s,al,k] == 1;
  forall( s in State )
    ct3:
    	sum(af in Action_F) phi[s,af] == 1;
  forall( s in State, af in Action_F )
    ct4_1:
    	0 <= V_F[s]-sum (al in Action_L, k in P_K) (Probability[k]*(R_F[s,al,af]*d[s,al,k]+Gamma_F*z[s,al,af,k]));
  forall( s in State, af in Action_F )
    ct4_2:
    	V_F[s]-sum(al in Action_L, k in P_K) (Probability[k]*(R_F[s,al,af]*d[s,al,k]+Gamma_F*z[s,al,af,k])) <= (1-phi[s,af])*Z;
  forall( s in State, af in Action_F )
    ct5:
    	V_L[s]-sum(al in Action_L, k in P_K) (Probability[k]*(R_L[s,al,af]*d[s,al,k]+Gamma_L*w[s,al,af,k])) <= (1-phi[s,af])*Z;
  forall( s in State, al in Action_L, af in Action_F, k in P_K)
    ct6:
    	w[s,al,af,k] >= sum (s_next in State) (T[af,s,s_next]*V_L[s_next])-Z*(1-d[s,al,k]);
  forall( s in State, al in Action_L, af in Action_F, k in P_K)
    ct7:
    	w[s,al,af,k]<=sum (s_next in State) (T[af,s,s_next]*V_L[s_next])+Z*(1-d[s,al,k]);
  forall( s in State, al in Action_L, af in Action_F, k in P_K) 
  	ct8_1:
    	-Z*d[s,al,k] <= w[s,al,af,k];
  forall( s in State, al in Action_L, af in Action_F, k in P_K)  
    ct8_2:
    	w[s,al,af,k] <= Z*d[s,al,k];
  forall( s in State, al in Action_L, af in Action_F, k in P_K)  
    ct9:
    	 z[s,al,af,k] >= sum (s_next in State) (T[af,s,s_next]*V_F[s_next])-Z*(1-d[s,al,k]);
  forall( s in State, al in Action_L, af in Action_F, k in P_K) 
    ct10:
    	z[s,al,af,k] <= sum (s_next in State) (T[af,s,s_next]*V_F[s_next])+Z*(1-d[s,al,k]);
  forall( s in State, al in Action_L, af in Action_F, k in P_K) 
    ct11_1:
    	-Z*d[s,al,k] <= z[s,al,af,k];
  forall( s in State, al in Action_L, af in Action_F, k in P_K)
    ct11_2:
    	z[s,al,af,k] <= Z*d[s,al,k];
}

