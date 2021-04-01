#!/usr/bin/perl
# this simple script is used to estimate the lines of code of the original files
# , to manage the language porting progress and to create a burn down graph

# import some modules
use File::Basename;
use File::Find;
use strict;

# set and get some variables
my $dirname = dirname(__FILE__);
my $matlabdir = '/home/johann/DEV/MagMechFEM_Forge1/';
my $graphfile = 'BurnDownGraph.svg';
my $progressfile = "PROGRESS.md";
my $tempfile = 'tempfile.md';
my $tempdata = 'tempdata.csv';
my ($sec, $min, $hour, $day, $month, $year) = gmtime(time);
$year += 1900; $month += 1;
my @timestamp = (sprintf("%04d-%02d-%02d",$year,$month,$day), sprintf("%02d:%02d:%02d",$hour,$min,$sec));

# assure that the script is run in .dev/
chdir($dirname);

# create or update the $progressfile
if(not -f $progressfile){
	open(PROGRESSFILE,">$progressfile") or die "Could not open file $progressfile, $!";
	# find all files of interest and print them to the $progressfile
	print PROGRESSFILE "[ |x] `file` : [#lines,#comments,#code,#countas,#timeneeded]\n";
	find(\&process_files,$matlabdir);
	close(PROGRESSFILE) or die "Could not close $progressfile, $!\n";
	exit;
}else{
	my $line;
	my @data_sum = (0, 0, 0, 0, 0.00);
	my @data_done = (0, 0, 0, 0, 0.00);
	my @temp;
	my @data;
	my $file;
	rename($progressfile,$tempfile);
	open(TEMPFILE,"<$tempfile") or die "Could not open file $tempfile, $!\n";
	open(PROGRESSFILE,">$progressfile") or die "Could not open file $progressfile, $!\n";
	while($line = <TEMPFILE>){
		print PROGRESSFILE "$line";
		last if($line =~ m/^\[ \|x\] .*$/);
	}
	my $progressflag = 0;
	while($line = <TEMPFILE>){
		if($line =~ m/^\s*$/){
			print PROGRESSFILE "\n";
			next;
		}
		if($line =~ m/^\s*#\s*PROGRESS\s*$/){
			print PROGRESSFILE "# PROGRESS\n";
			$progressflag = 1;
			last;
		}
		if(@temp = ($line =~ m/^\- \[([ x]{1})\]\s+`(.+)`\s+:\s+\[([\d,\. ]+)\]\s*$/)){
			if(@data = ($temp[2] =~ m/^([\d]+),([\d]+),([\d]+),([\d\.]+),([\d\.]+)$/)){
				print PROGRESSFILE "- [$temp[0]] `$temp[1]` : [$data[0],$data[1],$data[2],$data[3],$data[4]]\n";
				$data_sum[0] += $data[0];
				$data_sum[1] += $data[1];
				$data_sum[2] += $data[2];
				$data_sum[3] += $data[3];
				$data_sum[4] += $data[4];
				if($temp[0] eq 'x'){
					$data_done[0] += $data[0];
					$data_done[1] += $data[1];
					$data_done[2] += $data[2];
					$data_done[3] += $data[3];
					$data_done[4] += $data[4];
				}
			}else{
				print "Could not parse data $temp[2], (deleting line) $!\n";
			}
		}elsif(@temp = ($line =~ m/^\- \[([ x]{1})\]\s+`(.+)`\s*$/)){
			$file = File::Spec->catfile($matlabdir,$temp[1]);
			if(-f $file){
				my @lines = &process_file($file);
				if(defined $lines[0]){
					print PROGRESSFILE "- [ ] `$temp[1]` : [$lines[0],$lines[1],$lines[2],1,0.00]\n";
					$data_sum[0] += $lines[0];
					$data_sum[1] += $lines[1];
					$data_sum[2] += $lines[2];
					$data_sum[3] += 1;
					$data_sum[4] += 0.00;
				}else{print "Could not parse $file, (deleting line) $!\n";}
			}else{print "Could not find $file, (deleting line) $!\n";}
		}else{print "Could not read line: $line (line removed!) $!\n";}
	}
	print "current progress: done/sum\n";
	print "total lines           :  $data_done[0]/$data_sum[0]\n";
	print "comments              : $data_done[1]/$data_sum[1]\n";
	print "lines of code         : $data_done[2]/$data_sum[2]\n";
	print "files                 : $data_done[3]/$data_sum[3]\n";
	print "time wasted           : $data_done[4]/$data_sum[4]\n\n";
	if(1-$progressflag){
		print PROGRESSFILE "# PROGRESS\n\n";
		print PROGRESSFILE "[timestamp] : [data_sum] [data_done] [data_sum_diff] [data_done_diff]\n";
	}else{
		while($line = <TEMPFILE>){
			print PROGRESSFILE "$line";
			if($line =~ m/^\s*\[timestamp\].*$/){last;}
		}
	}
	# NOTE: i assume that the progresslist is sorted (by timestamp and logical changes
	$progressflag = 0;
	my $errorflag = 0;
	my @temp_data_sum;
	my @temp_data_done;
	my @temp_data_sum_diff;
	my @temp_data_done_diff;
	my @temp_timestamp;
	my %daydata;
	while($line = <TEMPFILE>){
		if($line =~ m/^\s*$/){next;}
		if(@temp = ($line =~ m/^\[([\d\-]+) ([\d\:]+)\] : \[([\d,\-\. ]+)\] \[([\d,\-\. ]+)\] \[([\d,\-\. ]+)\] \[([\d,\-\. ]+)\]$/)){
			$progressflag = 1;
			$errorflag = 0;
			@temp_timestamp = ($temp[0], $temp[1]);
			if(@temp_data_sum = ($temp[2] =~ m/^([\d\-]+),([\d\-]+),([\d\-]+),([\d\-\.]+),([\d\-\.]+)$/)){
			}else{print "Could not read $temp[2], $!\n"; $errorflag = 1;}
			if(@temp_data_done = ($temp[3] =~ m/^([\d\-]+),([\d\-]+),([\d\-]+),([\d\-\.]+),([\d\-\.]+)$/)){
			}else{print "Could not read $temp[3], $!\n"; $errorflag = 1;}
			if(@temp_data_sum_diff = ($temp[4] =~ m/^([\d\-]+),([\d\-]+),([\d\-]+),([\d\-\.]+),([\d\-\.]+)$/)){
			}else{print "Could not read $temp[4], $!\n"; $errorflag = 1;}
			if(@temp_data_done_diff = ($temp[5] =~ m/^([\d\-]+),([\d\-]+),([\d\-]+),([\d\-\.]+),([\d\-\.]+)$/)){
			}else{print "Could not read $temp[5], $!\n"; $errorflag = 1;}
			if(not $errorflag){
				print PROGRESSFILE "[@temp_timestamp] : [".join(',',@temp_data_sum)."] [".join(',',@temp_data_done)."] [".join(',',@temp_data_sum_diff)."] [".join(',',@temp_data_done_diff)."]\n";
				# NOTE: i assume that the progresslist is sorted (by timestamp and logical changes
				update_hashmap(\@temp_timestamp,\@temp_data_sum,\@temp_data_done,\@temp_data_sum_diff,\@temp_data_done_diff,\%daydata);
			}
		}else{print "Could not read $line (line removed!) $!\n";}
	}
	if($progressflag and not $errorflag){
		$temp_data_sum_diff[0] = $data_sum[0] - $temp_data_sum[0];
		$temp_data_sum_diff[1] = $data_sum[1] - $temp_data_sum[1];
		$temp_data_sum_diff[2] = $data_sum[2] - $temp_data_sum[2];
		$temp_data_sum_diff[3] = sprintf("%.2f",$data_sum[3] - $temp_data_sum[3]);
		$temp_data_sum_diff[4] = sprintf("%.3f",$data_sum[4] - $temp_data_sum[4]);
		$temp_data_done_diff[0] = $data_done[0] - $temp_data_done[0];
		$temp_data_done_diff[1] = $data_done[1] - $temp_data_done[1];
		$temp_data_done_diff[2] = $data_done[2] - $temp_data_done[2];
		$temp_data_done_diff[3] = sprintf("%.2f",$data_done[3] - $temp_data_done[3]);
		$temp_data_done_diff[4] = sprintf("%.3f",$data_done[4] - $temp_data_done[4]);
		$data_sum[3] = sprintf("%.2f",$data_sum[3]);
		$data_sum[4] = sprintf("%.3f",$data_sum[4]);
		$data_done[3] = sprintf("%.2f",$data_done[3]);
		$data_done[4] = sprintf("%.3f",$data_done[4]);
		print PROGRESSFILE "[@timestamp] : [".join(',',@data_sum)."] [".join(',',@data_done)."] [".join(',',@temp_data_sum_diff)."] [".join(',',@temp_data_done_diff)."]\n";
		# NOTE: i assume that the progresslist is sorted (by timestamp and logical changes
		update_hashmap(\@timestamp,\@data_sum,\@data_done,\@temp_data_sum_diff,\@temp_data_done_diff,\%daydata);
		print ":::[@timestamp]:::\n";
		print "overall changes:\n";
		print "delta total lines     : $temp_data_sum_diff[0]\n";
		print "delta comments        : $temp_data_sum_diff[1]\n";
		print "delta lines of code   : $temp_data_sum_diff[2]\n";
		print "delta files           : $temp_data_sum_diff[3]\n";
		print "delta time wasted     : $temp_data_sum_diff[4]\n";
		print "changes done:\n";
		print "delta total lines     : $temp_data_done_diff[0]\n";
		print "delta comments        : $temp_data_done_diff[1]\n";
		print "delta lines of code   : $temp_data_done_diff[2]\n";
		print "delta files           : $temp_data_done_diff[3]\n";
		print "delta time wasted     : $temp_data_done_diff[4]\n";
	}else{
		$data_sum[3] = sprintf("%.2f",$data_sum[3]);
		$data_sum[4] = sprintf("%.3f",$data_sum[4]);
		$data_done[3] = sprintf("%.2f",$data_done[3]);
		$data_done[4] = sprintf("%.3f",$data_done[4]);
		@temp_data_sum_diff = (0,0,0,0.0,0.0);
		@temp_data_done_diff = (0,0,0,0.0,0.0);
		print PROGRESSFILE "[@timestamp] : [".join(',',@data_sum)."] [".join(',',@data_done)."] [0,0,0,0.0,0.0] [0,0,0,0.0,0.0]\n";
		# NOTE: i assume that the progresslist is sorted (by timestamp and logical changes
		update_hashmap(\@timestamp,\@data_sum,\@temp_data_done,\@temp_data_sum_diff,\@temp_data_done_diff,\%daydata);
	}
	close(TEMPFILE) or die "Could not close file $tempfile $!\n";
	unlink($tempfile);
	close(PROGRESSFILE) or die "Could not close file $progressfile $!\n";
	if($progressflag and scalar(keys(%daydata)) gt 1){
		open(CSVFILE,">$tempdata") or die "Could not open file $tempdata, $!\n";
		print CSVFILE "# day, " .
		              "total lines, total comments, total lines of code, number of files, total time, " .
		              "total lines done, total comments done, total lines of code done, number of files done, total time used, " .
		              "changes on total lines, changes on total comments, changes on total lines of code, changes on number of files, changes on total time, " .
		              "changes on lines done, changes on comments done, changes on lines of code done, changes on files done, changes on total time used\n";
		foreach my $x (sort keys %daydata){
			print CSVFILE "$x, ".join(', ',@{$daydata{$x}}[1..20])."\n";
		}
		close(CSVFILE) or die "Could not close file $tempdata $!\n";
		system("gnuplot BurnDownGraph.gnuplot");
	}
	exit;
}

# subroutines

# subroutin for updating the hash array
sub update_hashmap{
	my ($timestamp, $data_sum, $data_done, $data_sum_diff, $data_done_diff, $hash_map) = @_;
	if(exists ${$hash_map}{${$timestamp}[0]}){
		my @temparray = @{${$hash_map}{${$timestamp}[0]}};
		$temparray[ 0] = ${$timestamp}[1];
		@temparray[ 1.. 5] = @{$data_sum}[0..4];
		@temparray[ 6..10] = @{$data_done}[0..4];
		$temparray[11] = $temparray[11] + ${$data_sum_diff}[0];
		$temparray[12] = $temparray[12] + ${$data_sum_diff}[1];
		$temparray[13] = $temparray[13] + ${$data_sum_diff}[2];
		$temparray[14] = $temparray[14] + ${$data_sum_diff}[3];
		$temparray[15] = $temparray[15] + ${$data_sum_diff}[4];
		$temparray[16] = $temparray[16] + ${$data_done_diff}[0];
		$temparray[17] = $temparray[17] + ${$data_done_diff}[1];
		$temparray[18] = $temparray[18] + ${$data_done_diff}[2];
		$temparray[19] = $temparray[19] + ${$data_done_diff}[3];
		$temparray[20] = $temparray[20] + ${$data_done_diff}[4];
		${$hash_map}{${$timestamp}[0]} = \@temparray;
	}else{
		my @temparray = (${$timestamp}[1], @{$data_sum}, @{$data_done}, @{$data_sum_diff}, @{$data_done_diff});
		${$hash_map}{${$timestamp}[0]} = \@temparray;
	}
}

# function to call line of code estimation routine
sub process_file{
	my $file = $_[0];
	my $flag = 0;
	my $lall; my $code; my $comm;
	if($file =~ /\.c$/){
		($lall, $comm, $code) = &estimate_loc($file,'\/\/','\/\*','\*\/');
		$flag = 1;
	}elsif($file =~ /\.m$/){
		($lall, $comm, $code) = &estimate_loc($file,'%'   ,'%\{' ,'%\}' );
		$flag = 1;
	}
	if($flag){return ($lall, $comm, $code);}else{return undef;}
}

# kernel for recursive file walk and reporting to overview
sub process_files{
	if(-f $_){
		my $varfile = $File::Find::name;
		my @lines = &process_file($varfile);
		if(defined $lines[0]){
			$varfile =~ s/($matlabdir)//;
			print PROGRESSFILE "- [ ] `$varfile` : [$lines[0],$lines[1],$lines[2],1,0.00]\n";
		}
	}
}

# subroutine for lines of code estimation (quick and dirty nothing accurate)
sub estimate_loc {
	my $file = $_[0];
	my $cblockflag = 0;
	my $cline = $_[1];
	my $cblockstart = $_[2]; my $cblockend = $_[3];
	my $line;
	my $count_lcomm = 0; my $count_lcode = 0; my $count_lines = 0;
	# do line counting
	open(SFILE,"<$file") or die "Could not open file $file $!\n";
	while($line = <SFILE>){
		++$count_lines;
		if($line =~ m/^\s*$/){next;
		}elsif($line =~ m/^\s*($cline).*$/){
			++$count_lcomm;
			next;
		}elsif($line =~ m/^\s*($cblockstart).*($cblockend)\s*$/){
			++$count_lcomm;
			next;
		}elsif($line =~ m/^\s*($cblockstart)((?!($cblockend)).)*$/){
			++$count_lcomm;
			$cblockflag = 1;
			next;
		}elsif($line =~ m/($cblockstart)((?!($cblockend)).)*$/){
			++$count_lcomm;
			++$count_lcode;
			$cblockflag = 1;
			next;
		}elsif($cblockflag){
			if($line =~ m/($cblockend)\s*$/){
				++$count_lcomm;
				$cblockflag = 0;
				next;
			}elsif($line =~ m/($cblockend)$/){
				++$count_lcomm;
				++$count_lcode;
				$cblockflag = 0;
				next;
			}else{++$count_lcomm;}
		}else{++$count_lcode;}
	}
	close(SFILE) or die "Could not close file $file $!\n";
	return ($count_lines, $count_lcomm, $count_lcode);
}
