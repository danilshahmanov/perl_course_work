#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use FindBin;
use lib $FindBin::Bin;
use FileHandler;

my $cgi = CGI->new;

print $cgi->header(-type => 'text/html', -charset => 'UTF-8');

my $upload_filehandle = $cgi->upload('file');
my $filename = $cgi->param('file');
my $encoding = $cgi->param('encoding');

print $cgi->start_html(
    -title => 'Результат обработки файла',
    -style => { -src => '../styles.css' }
);
print $cgi->h1("Результат изменения кодировки файла");

my $new_filename = FileHandler::process_encode_file($upload_filehandle, $filename, $encoding);

my $download_url = "/downloads/$new_filename";

print $cgi->p("Файл успешно загружен и обработан.");
print $cgi->p("Целевая кодировка: $encoding") if $encoding;
print $cgi->p($cgi->a({-href => $download_url, -download => ''}, 'Скачать файл'));

print $cgi->p($cgi->a({-href => '/index.html'}, 'Вернуться на главную'));
print $cgi->end_html;