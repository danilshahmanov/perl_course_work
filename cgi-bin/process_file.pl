#!C:/Perl/perl/bin
use strict;
use warnings;
use CGI;
use lib '.';
use FileHandler;

my $cgi = CGI->new;

my $file = $cgi->param('file');
my $encoding = $cgi->param('encoding');

if ($file) {
    my $filename = $cgi->param('file');
    my $file_content = $cgi->param('file');
    
    my $file_path = FileHandler::save_file($file_content, $filename);

    my $new_file_path;
    if ($encoding) {
        $new_file_path = FileHandler::change_encoding($file_path, 'UTF-8', $encoding);
    }

    print $cgi->header('text/html');
    print "<h2>Файл успешно загружен и изменён</h2>";
    print "<p>Выбранная кодировка: $encoding</p>";
    print "<p>Изменённый файл сохранён по пути: $new_file_path</p>";
    print "<p><a href='/index.html'>Вернуться на главную</a></p>";
}
else {
    print $cgi->header('text/html');
    print "<h2>Ошибка: файл не был загружен</h2>";
}