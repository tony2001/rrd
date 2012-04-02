--TEST--
rrd_fetch test
--SKIPIF--
include('skipif.inc');
include('data/definition.inc');
if (!file_exists($data_moreDSDb)) {
	die("skip $data_moreDSDb doesnt' exist");
}
--FILE--
<?php
include('data/definition.inc');
var_dump(rrd_fetch($data_moreDSDb, array(
	"--start", "920804400",
	"--end", "920808000",
	"AVERAGE"
)));
?>
--EXPECTF--
array(4) {
  ["start"]=>
  int(920804400)
  ["end"]=>
  int(920808300)
  ["step"]=>
  int(300)
  ["data"]=>
  array(2) {
    ["speed1"]=>
    array(13) {
      [920804700]=>
      float(NAN)
      [920805000]=>
      float(0.04)
      [920805300]=>
      float(0.02)
      [920805600]=>
      float(0)
      [920805900]=>
      float(0)
      [920806200]=>
      float(0.033333333333333)
      [920806500]=>
      float(0.033333333333333)
      [920806800]=>
      float(0.033333333333333)
      [920807100]=>
      float(0.02)
      [920807400]=>
      float(0.02)
      [920807700]=>
      float(0.02)
      [920808000]=>
      float(0.013333333333333)
      [920808300]=>
      float(0.016666666666667)
    }
    ["speed2"]=>
    array(13) {
      [920804700]=>
      float(NAN)
      [920805000]=>
      float(0.056666666666667)
      [920805300]=>
      float(0.02)
      [920805600]=>
      float(0.0033333333333333)
      [920805900]=>
      float(0)
      [920806200]=>
      float(0.03)
      [920806500]=>
      float(0)
      [920806800]=>
      float(0.066666666666667)
      [920807100]=>
      float(0.02)
      [920807400]=>
      float(0.02)
      [920807700]=>
      float(0.02)
      [920808000]=>
      float(0.013333333333333)
      [920808300]=>
      float(0.016666666666667)
    }
  }
}