package FileHandler;

use strict;
use warnings;
use Encode;
use File::Basename;
use Encode::Guess;
use Encode qw(decode encode is_utf8);
use Text::Markdown 'markdown';
use HTML::WikiConverter;
use XML::LibXML;

# Функция для обработки кодировки файла
sub process_encode_file {
    my ($upload_filehandle, $filename, $target_encoding) = @_;

    my $basename = basename($filename);
    my $new_filename = "converted_$basename";
    my $output_path  = "downloads/$new_filename";

    local $/;
    my $raw = <$upload_filehandle>;

    my $source_encoding = detect_encoding($raw);

    my $content = $raw;
    if ($source_encoding && $source_encoding ne $target_encoding) {
        $content = Encode::decode($source_encoding, $raw);
        $content = Encode::encode($target_encoding, $content);
    }

    open my $out, '>:raw', $output_path or die "Невозможно сохранить файл: $!";
    print $out $content;
    close $out;

    return $new_filename;
}

# Функция для определения кодировки текста
sub detect_encoding {
    my ($text) = @_;

    my $decoder = Encode::Guess->guess($text);
    return $decoder->name || 'UTF-8';
}

# Функция для обработки формата файла
sub process_format_file {
    my ($upload_filehandle, $filename, $from, $to) = @_;

    my $new_filename;

    local $/;
    my $raw = <$upload_filehandle>;

    my $text = decode('UTF-8', $raw, Encode::FB_CROAK);

    my $converted;

    if ($from eq $to) {
        $converted = $text;
        $new_filename = "converted_format_$filename.md";
    }
    # Markdown → HTML
    elsif ($from eq 'markdown' && $to eq 'html') {
        $converted = markdown($text);
        $new_filename = "converted_format_$filename.html";
    }
    # HTML → Markdown
    elsif ($from eq 'html' && $to eq 'markdown') {
        my $wc = HTML::WikiConverter->new(dialect => 'Markdown');
        $converted = $wc->html2wiki(encode('UTF-8', $text));
        $new_filename = "converted_format_$filename.md";
    }
    # HTML → XML
    elsif ($from eq 'html' && $to eq 'xml') {
        my $doc = XML::LibXML->new->parse_html_string($text);
        $converted = $doc->toString(1);
        $new_filename = "converted_format_$filename.xml";
    }
    # Markdown → XML
    elsif ($from eq 'markdown' && $to eq 'xml') {
        my $html = markdown($text);
        my $doc = XML::LibXML->new->parse_html_string($html);
        $converted = $doc->toString(1);
        $new_filename = "converted_format_$filename.xml";
    }    
    else {
        die "Неподдерживаемая конвертация: $from → $to";
    }

    my $output_path  = "downloads/$new_filename";

    open my $out, '>:raw', $output_path or die "Ошибка сохранения: $!";
    print $out $converted;
    close $out;

    return $new_filename;
}

1;