package GLPKParseTools;
use Switch;
use strict;

sub new { bless {}, shift }

sub get_symbols { return shift->{symbols} }

sub Ctype_to_Rtype {
    my ($self, $ctype, $default) = @_;

    my $ret = $default ? $default : 'SEXP';
    switch ($ctype)
      {
        case /int/    { $ret = 'INTEGER' }
        case /char/   { $ret = 'CHARACTER' }
        case /double/ { $ret = 'NUMERIC' }
      }
    return $ret;
}

sub parse {
    my ($s, $line) = @_;

    $s->{symbols}          = undef;
    $s->{symbols}{LC}      = \&_LC;
    $s->{symbols}{TeXSafe} = \&_TeXSafe;
    $s->{symbols}{Clean}   = \&_Clean;
}


## Utilities -- as subroutines not methods

sub _LC { lc shift }

sub _TeXSafe {
    my ($line) = @_;
    $line =~ s/\_/\\_/g;
    return $line;
}

sub _Clean {
    my ($line) = @_;
    $line =~ s/\*//g;
    $line =~ s/\s+//g;
    return $line;
}

package GLPKDeclParser;
use base 'GLPKParseTools';

sub parse {
    my ($s, $line) = @_;

    $s->SUPER::parse($line);
    $s->_parse_glpk_method($line) or return undef;
}

sub _parse_glpk_method {
    my ($s, $line) = @_;

    my ($ret, $method, $par) = $line =~ /^(\w+\s\**)(\w+)\((.*)\)/;

    return undef if not $ret;

    $s->_build_symbols_glpk($line, $ret, $method, $par);
    $s->_build_symbols_R_c;
    $s->_build_symbols_R_r;

    return $s;
}

sub _build_symbols_glpk {
    my ($s, $dec, $ret, $method, $par) = @_;

    $s->{symbols}{glpk_dec} = $dec;

    ($s->{symbols}{glpk_method_ret} = $ret) =~ s/\s+$//;
    $s->{symbols}{glpk_method}     = $method;
    $s->{symbols}{glpk_method_par} = $par;

    $s->_build_symbols_glpk_class;

    return if $par eq 'void';

    my @pars = split ',', $par;

    for (@pars)
      {
        my ($type, $name, $array_sym) = /(\w+\s+\**)(\w+)([\[\]]*)/;
        warn "Regex match failed in GLPKParseTool::_build_symbols_glpk_method"
            if !$type;

        $type =~ s/\s+$//;
        $type = $type.' *' if $array_sym;

        push @{$s->{symbols}{glpk_method_par_types}}, $type;
        push @{$s->{symbols}{glpk_method_par_names}}, $name;
      }
}

sub _build_symbols_glpk_class {
    my ($s) = @_;

    my ($glpk_class) = $s->{symbols}{glpk_method} =~ /(^[A-Za-z0-9]+)_/;

    $s->{symbols}{glpk_class} = $glpk_class;
    $s->{symbols}{glpk_class_type} = uc $glpk_class; 
}

sub _build_symbols_R_c {
    my ($s) = @_;

    $s->_build_symbols_R_c_method;
    $s->_build_R_c_ret;
    $s->_build_R_c_par_lists;
}


sub _build_symbols_R_c_method {
    my ($s) = @_;

    $s->{symbols}{R_c_method} = 'R_'.$s->{symbols}{glpk_method};

    return if not $s->{symbols}{glpk_method_par_names};

    for (@{$s->{symbols}{glpk_method_par_names}})
      {
        push @{$s->{symbols}{R_c_method_par}}, 'SEXP '.$_;
      }

    for (@{$s->{symbols}{glpk_method_par_types}})
      {
        my $kind = (/\*/ && !/char\s+\*/) ? 'POINTER' : 'VALUE';
        push @{$s->{symbols}{R_c_par_kind}}, $kind;
      }
}

sub _build_R_c_ret {
    my ($s) = @_;

    $s->{symbols}{R_c_ret} = $s->Ctype_to_Rtype($s->{symbols}{glpk_method_ret});
}

sub _build_R_c_par_lists {
    my ($s) = @_;

    return if not $s->{symbols}{glpk_method_par_names};

    my $n = @{$s->{symbols}{glpk_method_par_names}};

    my @rtype;
    my @rtype_conv;
    for (my $i = 0; $i < $n; $i++)
     {
        my $ctype = $s->{symbols}{glpk_method_par_types}[$i];
        my $name = $s->{symbols}{glpk_method_par_names}[$i];
        my $kind = $s->{symbols}{R_c_par_kind}[$i];

        my $rtype = $s->Ctype_to_Rtype($ctype, 'R_ExternalPtrAddr');

        my $conv;
        if ($rtype eq 'R_ExternalPtrAddr') 
          { 
            $conv = sprintf "%s(%s)", $rtype, $name;
          }
        else
          {
            $conv = sprintf "%s_%s(%s)", $rtype, $kind, $name;
          }


        push @rtype, $rtype;
        push @rtype_conv, $conv;
     }

    $s->{symbols}{R_c_par} = \@rtype;
    $s->{symbols}{R_c_par_conv} = \@rtype_conv;
}

sub _build_symbols_R_r {
    my ($s) = @_;

    #($s->{symbols}{R_r_method} = $s->{symbols}{glpk_method}) =~ s/\_/\./g;
    $s->{symbols}{R_r_method} = $s->{symbols}{glpk_method};

    return if not exists $s->{symbols}{glpk_method_par_names};

    my $n = @{$s->{symbols}{glpk_method_par_names}};

    for (my $i = 0; $i < $n; $i++)
      {
        my $r_par_name = $s->{symbols}{glpk_method_par_names}[$i];
        $r_par_name =~ s/\_/\./g;
        push @{$s->{symbols}{R_r_method_par}}, $r_par_name;


        my $r_c_par = $s->{symbols}{R_c_par}[$i];

        my $r_par_conv;
        if ($r_c_par eq 'R_ExternalPtrAddr') { $r_par_conv = $r_par_name }
        else 
          { 
            my $r_c_par_kind = $s->{symbols}{R_c_par_kind}[$i];
            if ($r_c_par_kind eq 'POINTER')
              {
                $r_par_name = sprintf "c(0,%s)", $r_par_name;
              }

            $r_par_conv = sprintf "as.%s(%s)", lc $r_c_par, $r_par_name;
          }

        push @{$s->{symbols}{R_r_par_conv}}, $r_par_conv;
      }
}

package GLPKDefineVarParser;
use base 'GLPKParseTools';

sub parse {
    my ($s, $line) = @_;

    $s->SUPER::parse($line);
    $s->_parse_glpk_define($line) or return undef;
}

sub _parse_glpk_define {
    my ($s, $line) = @_;

    my ($var, $val, $expl) = $line =~ /^#define\s+([A-Z_]+)\s+([0-9]+)\s+(.*)/;

    return undef if not $var;

    $expl =~ s/\/|\*//g;
    $expl =~ s/^\s*|\s*$//g;

    $s->{symbols}{glpk_var}  = $var;
    $s->{symbols}{glpk_val}  = $val;
    $s->{symbols}{glpk_expl} = $expl;

    #$var =~ s/_/\./g;

    $s->{symbols}{R_var}  = $var;
    $s->{symbols}{R_val}  = $val;
    $s->{symbols}{R_expl} = $expl;

    return $s;
}


1;

