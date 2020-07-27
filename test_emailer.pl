use strict;
use warnings;

use Email::MIME;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP;
use IO::All;
use Email::Simple::Creator ();

my $smtpserver = 'smtp.gmail.com';
my $smtpport = 587;
my $smtpuser   = '@gmail.com';
my $smtppassword = '';

my $transport = Email::Sender::Transport::SMTP->new({
  host => $smtpserver,
  ssl  => 'starttls',
  port => $smtpport,
  sasl_username => $smtpuser,
  sasl_password => $smtppassword,
  debug => 0,
});

sub send_email {
    my $filename = shift;
    my $rec = shift;
    my $quarter = shift;

    # multipart message
    my @parts = (
        Email::MIME->create(
            attributes => {
                filename     => $filename.".pdf",
                content_type => "application/pdf",
                encoding     => "base64",
                name         => $filename.".pdf",
            },
            body => io( "doc/".$filename.".pdf" )->binary->all,
        ),
        Email::MIME->create(
            attributes => {
                content_type => "text/plain",
                disposition  => "attachment",
                charset      => "US-ASCII",
                encoding     => "base64",
            },
            body_str => "Please submit your due declaration\n",
        ),
    );

    my $email = Email::MIME->create(
      header_str => [
        To      =>  $rec,
        From    => '@gmail.com',
        Subject => 'Due Notification for '.$quarter,
      ],
      parts     => [ @parts ],
    );

    sendmail($email, { transport => $transport });
};

send_email('Justin_Yau', 'justiceman8998@gmail.com', '20202');