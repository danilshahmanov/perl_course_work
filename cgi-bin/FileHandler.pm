package FileHandler;

use strict;
use warnings;
use Encode;
use File::Slurp;

sub save_file {
    my ($file, $filename) = @_;
    
    open my $fh, '>', "/tmp/$filename" or die "Не могу открыть файл для записи: $!";
    print $fh $file;
    close $fh;
    
    return "/tmp/$filename";
}

sub change_encoding {
    my ($file_path, $from_encoding, $to_encoding) = @_;
    
    my $content = read_file($file_path, binmode => ':raw');
    
    my $decoded_content = decode($from_encoding, $content);
    my $encoded_content = encode($to_encoding, $decoded_content);

    write_file($file_path, $encoded_content);
    
    return $file_path;
}

1;