CREATE DATABASE devopstravel;
CREATE USER 'codeuser'@'%' IDENTIFIED BY 'codepass';
GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'%';
FLUSH PRIVILEGES;