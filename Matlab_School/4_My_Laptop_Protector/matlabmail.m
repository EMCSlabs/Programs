function matlabmail(recipient, message, subject, sender, psswd, attachments)
% Modified for gmail
% For group 4 only
% smtp and account information should be checked first
%
% usage: MATLABMAIL('EMAIL@korea.ac.kr',{'Hi','Nice to meet you'},'Hello','matlabgroup4@gmail.com','PASSWORD',[])
% usage: MATLABMAIL('EMAIL@korea.ac.kr',{'Hi','Nice to meet you'},'Hello','matlabgroup4@gmail.com','PASSWORD','file.txt')
%
% For more detail:
% http://kr.mathworks.com/help/matlab/ref/sendmail.html
% https://dgleich.wordpress.com/2014/02/27/get-matlab-to-email-you-when-its-done-running/

if nargin < 5
    help matlabmail
    return
end

setpref('Internet','E_mail',sender);
setpref('Internet','SMTP_Server','smtp.gmail.com'); % change here
setpref('Internet','SMTP_Username',sender);
setpref('Internet','SMTP_Password',psswd);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
                  'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
% encoding = slCharacterEncoding()
encoding = 'UTF-8';
setpref('Internet','E_mail_Charset',encoding)

disp('sending email...')
if isempty(attachments)
    sendmail(recipient, subject, message);
    fprintf('email sent to %s\n',recipient)
else
    sendmail(recipient, subject, message, attachments);
    fprintf('email sent to %s with attachment\n',recipient)
end

