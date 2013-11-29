function email(message)

allow = true;

if allow
    % Modify these two lines to reflect
    % your account and password.
    myaddress = 'bk12369@bristol.ac.uk';
    mypassword = '2April2013';

    try
        setpref('Internet','E_mail',myaddress);
        setpref('Internet','SMTP_Server','smtp.gmail.com');
        setpref('Internet','SMTP_Username',myaddress);
        setpref('Internet','SMTP_Password',mypassword);
        props = java.lang.System.getProperties;
        props.setProperty('mail.smtp.auth','true');
        props.setProperty('mail.smtp.socketFactory.class', ...
                          'javax.net.ssl.SSLSocketFactory');
        props.setProperty('mail.smtp.socketFactory.port','465');
        sendmail(myaddress, 'OSM alert', message);
        disp('Notification by email sent.');
    catch err
        err
    end
end