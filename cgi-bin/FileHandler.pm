package FileHandler;

use strict;
use warnings;
use Encode;
use File::Basename;
use Encode::Detect;

# Функция для обработки кодировки файла
sub process_file {
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

    my $detected = Encode::Detect::detect($text);
    return $detected || 'UTF-8';
}

1;