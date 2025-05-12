#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use FindBin;
use lib $FindBin::Bin;
use FileHandler;

my $cgi = CGI->new;

my %ext_to_format = (
    'md'   => 'markdown',
    'markdown' => 'markdown',
    'html' => 'html',
    'htm'  => 'html',
);

my $upload_filehandle = $cgi->upload('file');
my $filename = $cgi->param('file');

my ($basename, $ext) = $filename =~ /^(.*)\.([^.]+)$/;

my $input_format = $ext_to_format{$ext};
my $output_format = $cgi->param('output_format');

print $cgi->header(-type => 'text/html', -charset => 'UTF-8');

print $cgi->start_html(
    -title => 'Результат обработки файла',
    -style => { -src => '../styles.css' }
);

if ($input_format) {
    print $cgi->h1("Результат изменения формата файла");

    my $new_filename = FileHandler::process_format_file($upload_filehandle, $basename, $input_format, $output_format);

    my $download_url = "/downloads/$new_filename";

    print $cgi->p("Файл успешно загружен и обработан.");
    print $cgi->p("Начальный формат: $input_format");
    print $cgi->p("Конечный формат: $output_format");

    print $cgi->p($cgi->a({-href => $download_url, -download => ''}, 'Скачать файл'));
}
else{
    print $cgi->h1("Неподдерживаемый формат файла");
}


print $cgi->p($cgi->a({-href => '/index.html'}, 'Вернуться на главную'));
print $cgi->end_html;
