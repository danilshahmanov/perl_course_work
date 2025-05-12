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
    -method => 'POST',
    -action => '/cgi-bin/format_file.pl',
    -class   => 'form-custom'
);

print $cgi->label({ -for => 'file' }, 'Выберите файл:');
print $cgi->filefield(
    -name     => 'file',
    -id       => 'file',
    -required => 'required'
);

print $cgi->label({ -for => 'output_format' }, 'Конечный формат:');
print $cgi->popup_menu(
    -name    => 'output_format',
    -id      => 'output_format',
    -values  => ['html', 'markdown', 'xml'],
    -default => 'markdown'
);

print $cgi->submit(-value => 'Загрузить и конвертировать');
print $cgi->end_form;

print $cgi->p($cgi->a({-href => '/index.html'}, 'Вернуться на главную'));

print $cgi->end_html;