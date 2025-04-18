%this script is used for constructing control frame
Mode_Reg=U6G.OpMode;


switch (U6G.OpMode)
    case {3} %load Mag
           
    CtrlFrame_tmp=[0 0 U6G.ChEN4 U6G.ChEN3 U6G.ChEN2 U6G.ChEN1];
    
    case {4}  %normal operation
        Freq_H=floor(U6G.LO_Freq/256);
        Freq_L=rem(U6G.LO_Freq,256); 
        
        CtrlFrame_tmp=[0 0 0 U6G.LO_Sel Freq_H Freq_L];
        
    case {161} %load Mag
          
    CtrlFrame_tmp=[0 0 0 0 U6G.exTR_EN*128+U6G.T_Att 4*U6G.R_Att+2*U6G.TEN+U6G.REN];
    
    otherwise
        CtrlFrame_tmp=[0 0 0 0];
            disp('Invalid Mode!All reg-bits are forced to zeros...')
end

CtrlPacket=[CtrlFrame_tmp Mode_Reg]