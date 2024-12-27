function [] = executeFunctionGivenCommand(functioni,fcScope)
%EXECUTEFUNCTIONGIVENCOMMAND Summary of this function goes here
%   Detailed explanation goes here

func = str2func(functioni{1});
argList = functioni{2};
func(argList,'fcScope',fcScope);

end

