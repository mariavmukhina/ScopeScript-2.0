function varargout = printCurrentBFLightSourceState()
%PRINTCURRENTBFLIGHTSOURCESTATE prints current PEka BF LED state

global ti2;

I = num2str(get(ti2,'iDIA_LAMP_Pos'));


output = 'I_BF=%s';

if nargout == 0
   fprintf(output,I); 
   fprintf('\n');
else
   varargout{1} = sprintf(output,I);
end

end

