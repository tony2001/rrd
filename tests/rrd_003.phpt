--TEST--
RRDCreator test
--SKIPIF--
<?php include('skipif.inc'); ?>
--FILE--
<?php
$rrdFile = dirname(__FILE__) . "/creator-test.rrd";
$creator = new RRDCreator($rrdFile, "now -10d", 500);
$creator->addDataSource("speed:COUNTER:600:U:U");
$creator->addArchive("AVERAGE:0.5:1:24");
$creator->addArchive("AVERAGE:0.5:6:10");
$creator->save();
var_dump(file_exists($rrdFile));
?>
--EXPECTF--
bool(true)
