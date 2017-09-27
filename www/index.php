<?php

include '_browser/functions.php';
include '_browser/parser.php';


$root = __DIR__;
$parse = new Parsedown();

$ignore = array(
	$root.'/index.php',
	$root.'/404.html',
	$root.'/50x.html',
	$root.'/_browser'
);

processpath($root);

if (empty($path)) {
	define('ROOT', true);
}
else {
	define('ROOT', false);
}

$title = explode('/', $path);

?>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>localhost <?php echo implode(' &rsaquo; ', $title); ?></title>
		<script src="https://code.jquery.com/jquery-2.2.1.min.js"></script>

		<!-- Latest compiled and minified CSS -->
		<link rel="stylesheet" href="https://bootswatch.com/darkly/bootstrap.min.css" crossorigin="anonymous">


		<!-- Latest compiled and minified JavaScript -->
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" crossorigin="anonymous"></script>

		<style>
		body {
			font-size: 13px;
		}
		.item.folder:hover:after {
			content: " »";
		}
		</style>
	</head>

	<body id="">
		<div class="container-fluid">
			<h1><a href="/">Local Development Environment</a></h1>
			<br />
			<div class="row">
				<div class="col-md-7">

					<?php if (isset($_GET['error']) && $_GET['error'] == 404): ?>
						<div class="alert alert-danger" role="alert"><strong>Oooops</strong> the page you requested does not exist. Because we hate white pages, here is the homepage instead...</div>
					<?php endif; ?>


					<?php $files = getglob($root.'/*'); ?>

					<fieldset>
						<div class="panel panel-default">
							<div class="panel-heading">
								<h3 class="panel-title">Listing documents</h3>
							</div>

							<div class="panel-body">
								<?php if (!empty($path) && isset($files['index'])): ?>
									<div class="row">
										<div class="col-md-8">
											<span class="glyphicon glyphicon-play"></span>&nbsp;We have found an "<?php echo $files['index']; ?>" file&nbsp;&nbsp;
										</div>
										<div class="col-md-4">
											<a class="btn btn-primary btn-xs" href="<?php echo $path; ?>/<?php echo $files['index']; ?>">Run it !</a>
										</div>
									</div>
								<?php endif; ?>
								<br />
								<div class="row">
									<div class="col-md-12">
										<ol class="breadcrumb">
											<li><a href="/">localhost</a></li>
											<?php $tmp = ''; ?>
											<?php foreach ($exp as $e): ?>
												<li><a href="/?p=<?php echo $tmp.$e; ?>"><?php echo $e; ?></a></li>
												<?php $tmp .= $e.'/'; ?>
											<?php endforeach; ?>
										</ol>
									</div>
								</div>


								<?php
									if (count($files) > 0) {
										echo '<table class="table table-bordered table-hover">';
										if (isset($files['folders'])) {
											//echo '<ul class="list-group">';
											echo '<tr><th>Name</th><th width="10%">Size</th><th width="20%">Modified</th></tr>';
											foreach ($files['folders'] as $f) {
												echo '
													<tr>
														<td>
															<span class="glyphicon glyphicon-folder-open"></span>&nbsp;&nbsp;
															<a href="/?p='.$path.'/'.$f.'" class="item folder"><strong>'.$f.'</strong></a>
														</td>
														<td>&nbsp;</td>
														<td>&nbsp;</td>
													</tr>
												';

											}
										}

										if (isset($files['files'])) {
											foreach ($files['files'] as $f) {
												echo '
													<tr>
														<td>
															<span class="glyphicon glyphicon-file"></span>&nbsp;
															<a href="'.$path.'/'.$f.'" class="item file">'.$f.'</a>
														</td>
														<td>'.round(filesize(__DIR__.'/'.$path.'/'.$f) / 1000, 2).' ko</td>
														<td>'.date('D, M Y', filemtime(__DIR__.'/'.$path.'/'.$f)).'</td>
													</tr>
												';
												//echo '<li class="list-group-item"><span class="glyphicon glyphicon-file"></span>&nbsp;<a href="/?f='.$path.'/'.$f.'">'.$f.'</a></li>';
											}
										}
										echo '</table>';
									}
									else {
										if (file_exists($root)) {
											echo '<div class="alert alert-info" role="alert"><strong>Oooops</strong> This directory is empty...</div>';
										}
										else {
											echo '<div class="alert alert-danger" role="alert"><strong>Oooops</strong> This directory does not exist. Use the breadcrumb to navigate away...</div>';
										}
									}
								?>
							</div>
						</div>

						<?php if (isset($files['readme'])): ?>
							<div class="panel panel-default">
								<div class="panel-heading">
									<h3 class="panel-title">Readme</h3>
								</div>

								<div class="panel-body" style="font-size: 13px;">
									<?php echo $parse->text(file_get_contents($files['readme'])); ?>
								</div>
							</div>
						<?php endif; ?>


					</fieldset>
				</div>
				<div class="col-md-5">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h3 class="panel-title">PHP Informations&nbsp;<small>&nbsp;[&nbsp;☛&nbsp;<a href="/_browser/php.php">Full</a>&nbsp;]</small></h3>
						</div>

						<div class="panel-body" style="max-height: 250px; overflow: auto;">
							<table class="table" style="font-size: 11px;">
								<tr style="font-size: 14px;background-color:#2c3e50;"><td width="30%">PHP Version</td><td><?php echo phpversion(); ?></td></tr>
								<tr><td width="30%">Loaded INI file</td><td><?php echo php_ini_loaded_file(); ?></td></tr>
								<tr><td width="30%">Additional INI files</td><td><?php echo php_ini_scanned_files(); ?></td></tr>
								<tr><td width="30%">PHP API type</td><td><?php echo php_sapi_name(); ?></td></tr>
								<tr style="font-size:14px;background-color:#2c3e50;"><td colspan="2">Modules</td></tr>
								<?php $extensions = get_loaded_extensions(); ?>
								<?php foreach ($extensions as $e): ?>
									<tr><td width="30%">»&nbsp;<?php echo $e; ?></td><td><?php echo cut(phpversion($e), 35); ?></td></tr>
								<?php endforeach; ?>
							</table>
						</div>
					</div>
					<div class="panel panel-default">
						<div class="panel-heading">
							<h3 class="panel-title">Server Informations</h3>
						</div>

						<div class="panel-body" style="max-height: 250px; overflow: auto;">
							<table class="table"style="font-size: 11px;">
								<?php foreach ($_SERVER as $k => $v): ?>
									<tr><td width="30%">&nbsp;»&nbsp;<?php echo $k; ?></td><td><?php echo cut($v, 35); ?></td></tr>
								<?php endforeach; ?>
							</table>
						</div>
					</div>
				</div>
			</div>
	</div>
	<br /><br />
	</body>
</html>

