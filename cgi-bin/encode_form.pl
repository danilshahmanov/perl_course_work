#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $cgi = CGI->new;

print $cgi->header(-type => 'text/html', -charset => 'UTF-8');
print $cgi->start_html(
    -title => 'Загрузка файла',
    -style => { -src => '../styles.css' },
);

print $cgi->h1('Загрузите файл');

print $cgi->start_multipart_form(
    -class   => 'form-custom',
    -method => 'POST',
    -action => '/cgi-bin/encode_file.pl'
);

print $cgi->label({ -for => 'file' }, 'Выберите файл для загрузки:');
print $cgi->filefield(
    -name     => 'file',
    -id       => 'file',
    -required => 'required'
);

print $cgi->label({ -for => 'encoding' }, 'Выберите кодировку:');
print $cgi->popup_menu(
    -name    => 'encoding',
    -id      => 'encoding',
    -values  => ['UTF-8', 'Windows-1251', 'ISO-8859-1', 'KOI8-R', 'ASCII', 'UTF-16'],
    -default => 'UTF-8'
);

print $cgi->submit(-value => 'Загрузить и конвертировать');
print $cgi->end_form;

print $cgi->p($cgi->a({-href => '/index.html'}, 'Вернуться на главную'));

print $cgi->end_html;