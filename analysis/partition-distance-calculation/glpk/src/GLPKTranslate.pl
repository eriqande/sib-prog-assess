use English;
use Getopt::Long;
use Switch;
use Template;
use GLPKParseTools;
use strict;

our $usage =  <<EOF;

Usage: $PROGRAM_NAME MODE [MODE_OPTIONS] HEADER_FILE

Examples:
    $PROGRAM_NAME --mode=api --templ=C_api.tt glplpx.h
    $PROGRAM_NAME --mode=var --debug glplpx.h

Availablie modes:
    api     Translate declarations to a API using a template.
    doc     Translate declarations to R documentation using a template.
    var     Translate GLPK C-define variables into R structures.
EOF

sub useage_info {
    print $usage;
    exit;
}

our ($Mode, $Help, $Templ, $Write, $Debug, $Output);

GetOptions("help"     => \$Help, 
           "mode=s"   => \$Mode,
           "templ=s"  => \$Templ, 
           "write"    => \$Write,
           "debug"    => \$Debug,
           "output=s" => \$Output);

useage_info if not $ARGV[0];
    
my $t;
switch ($Mode)
    {
        case 'api'   { $t = GLPKTranslatorAPI->new($ARGV[0]) }
        case 'doc'   { $t = GLPKTranslatorDoc->new($ARGV[0]) }
        case 'var'   { $t = GLPKTranslatorDefineVar->new($ARGV[0]) }
        else         { useage_info() }
    }
$t->translate;

package GLPKTranslator;
use Data::Dumper;

sub new { 
    my ($class, $file, $pt) = @_;

    bless { file => $file, 
            pt   => $pt ? $pt : new GLPKDeclParser,
            tt   => new Template,
    }, $class;
}

sub file { shift->{file} }
sub pt   { shift->{pt} }
sub tt   { shift->{tt} }

sub translate {
    my ($s) = @_;

    $s->usage_info if $Help;

    my $file = $s->file;
    open FILE, $file or die "Can't open file ($file) for translation!\n";

    my %data;
    while (<FILE>) 
      {
        chomp;
        next if not defined $s->pt->parse($_);
        push @{$data{symbols}}, $s->pt->get_symbols;
      }
    die "No matches!\n" if not defined @{$data{symbols}};

    return $Debug ? $s->debug(\%data) : \%data;
}

sub debug {
    my ($s, $data) = @_;
    print Dumper $data;
    exit;
}

package GLPKTranslatorAPI;
use base 'GLPKTranslator';
use English;

sub usage_info {
    print $usage;
    print <<EOF;

Options for $Mode mode:
    --templ=TEMPLATE_FILE   Template file to use (a la Perl Template Toolkit).
    [--debug]               Print parse structures and exit.

EOF
    exit;
}

sub translate {
    my ($s) = @_;

    my $data = $s->SUPER::translate;

    $s->usage_info if not $Templ;

    $s->tt->process($Templ, $data) || die $s->tt->error;
}

package GLPKTranslatorDoc;
use base 'GLPKTranslator';
use English;

sub usage_info {
    print $usage;
    print <<EOF;

Options for $Mode mode:
    --templ=TEMPLATE_FILE   Template file to use (a la Perl Template Toolkit).
    [--debug]               Print parse structures and exit.
    [--write]               Write to files instead of STDOUT.  This will
                            write R doc files named after the R functions.
                            (ie, lpx.create.prob.Rd).  Will not clobber
                            any existing files of the same name.

EOF
    exit;
}

sub translate {
    my ($s) = @_;

    my $data = $s->SUPER::translate;
    for (@{$data->{symbols}})
      {
       my $outfile = $_->{R_r_method}.'.Rd';
       $s->process_doc($data, $outfile);
      }
}

sub process_doc {
    my ($s, $data, $outfile) = @_;

    $s->usage_info if not $Templ;

    if (!$Write) { $s->tt->process($Templ, $data) || die $s->tt->error }
    else
      { 
        die "$outfile already exists!\n" if (-e $outfile);
        $s->tt->process($Templ, $_, $outfile) || die $s->tt->error; 
        printf "Wrote $outfile\n";
      }
}

package GLPKTranslatorDebug;
use base 'GLPKTranslator';

sub translate { shift->debug }

package GLPKTranslatorDefineVar;
use base qw(GLPKTranslator GLPKTranslatorDoc);
use Switch;

sub usage_info {
    print $usage;
    print <<EOF;

Options for $Mode mode:
    [--debug]                Print parse structures and exit.
    --output=[csv|Rvar|Rdoc  The type of output to produce:
                               csv   Produce a csv file for R read.csv().
                               Rvar  Produce R variable declarations.
                               Rdoc  Produce R docs for variables.
    If --output=Rdoc:
        --templ=TEMPLATE_FILE  Template file to use (a la Perl Template Toolkit).

EOF
    exit;
}

sub new {
    my ($class, $file) = @_;
    $class->SUPER::new($file, new GLPKDefineVarParser)
}

sub translate {
    my ($s) = @_;

    my $data = $s->SUPER::translate;

    $s->usage_info if not $Output;

    switch ($Output)
      {
        case 'csv'  { $s->var_csv($data) }
        case 'Rvar' { $s->var_R($data) }
        case 'Rdoc' { $s->var_R_doc($data) }
        else        
          { 
            print "\n** Error: Unrecognized output option in $Mode mode!\n";
            $s->usage_info;
          }
      }
}

sub var_csv {
    my ($s, $data) = @_;

    my %seen;
    print "symbol,value,string\n";
    for (@{$data->{symbols}})
      {
        next if exists $seen{$_->{R_var}};
        $seen{$_->{R_var}} = 1;

        printf "%s,%s,\"%s\"\n", 
            $_->{R_var}, $_->{R_val}, $_->{R_expl};
      }
}

sub var_R {
    my ($s, $data) = @_;

    my %seen;
    for (@{$data->{symbols}})
      {
        next if exists $seen{$_->{glpk_var}};
        $seen{$_->{glpk_var}} = 1;

        printf "%s = %s\n", $_->{R_var}, $_->{R_val};
      }
}

sub var_R_doc {
    my ($s, $data) = @_;

    $Write = undef;
    $s->process_doc($data);
}
