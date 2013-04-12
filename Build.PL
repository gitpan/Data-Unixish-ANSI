
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "dux functions related to text containing ANSI codes",
  "dist_author" => [
    "Steven Haryanto <stevenharyanto\@gmail.com>"
  ],
  "dist_name" => "Data-Unixish-ansi",
  "dist_version" => "0.01",
  "license" => "perl",
  "module_name" => "Data::Unixish::ansi",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Data::Unixish::Util" => "1.29",
    "Log::Any" => 0,
    "Text::ANSI::Util" => 0,
    "Unixish" => "v1.0.1",
    "perl" => "5.010001"
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
