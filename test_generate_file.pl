use strict;
use warnings;

use CAM::PDF;
use Time::Piece;

sub generate_new_file {
    my $name = shift;
    my $guildid = shift;
    my $address1 = shift;
    my $address2 = shift;
    my $address3 = shift;
    my $address4 = shift;
    my $gincome = shift;
    my $pdue = shift;
    my $bdue = shift;
    my $pbal = shift;
    my $nbal = shift;

    my $pdf = new CAM::PDF('base_doc.pdf') || die "$CAM::PDF::errstr\n";

    my $date = localtime->mdy('/');

    my %data = (
        'Name' => $name,
        'GuildID' => $guildid,
        'Date' => $date,
        'FullName' => $name,
        'Address1' => $address1,
        'Address2' => $address2,
        'Address3' => $address3,
        'Address4' => $address4,
        'GuildIncome' => $gincome,
        'PercentDue' => $pdue,
        'BasicDue' => $bdue,
        'PrevBalance' => $pbal,
        'NewBal' => $nbal,
    );

    print STDOUT $pdf->getFormFieldList;

    $pdf->fillFormFields(%data);
    $pdf->cleanoutput('doc/'.$guildid.'.pdf');
}

generate_new_file('Justin Yau', '10000', 'Bay Street', 'Test', 'Test1', 'Test2', '10', '20', '30', '40', '50');