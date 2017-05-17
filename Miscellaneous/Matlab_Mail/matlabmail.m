function matlabmail(recipient, message, subject, sender, psswd)
% modified for KU email
% it only works when the sender uses KU email
% smtp and account information should be checked first
%
% usage: MATLABMAIL('EMAIL@gmail.com',{'Hi','Nice to meet you'},'Hello','YOUR_EMAIL@korea.ac.kr','YOUR_PASSWORD')
%
% For more detail:
% http://kr.mathworks.com/help/matlab/ref/sendmail.html
% https://dgleich.wordpress.com/2014/02/27/get-matlab-to-email-you-when-its-done-running/

setpref('Internet','E_mail',sender);
setpref('Internet','SMTP_Server','smtp.korea.ac.kr'); % change here
setpref('Internet','SMTP_Username',sender);
setpref('Internet','SMTP_Password',psswd);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
                  'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

disp('sending email...')
sendmail(recipient, subject, message);
disp(sprintf('email sent to %s',recipient))
