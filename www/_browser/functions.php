<?php

function cut($text, $len) {
	if (strlen($text) > $len) {
		if ($len > 10) {
			$text = substr($text, 0, ($len - 5)).'[...]';
		}
		else {
			$text = substr($text, 0, $len);
		}
		
		
	}
	return $text;
}

function processpath(&$root) {
	global $path, $exp;

	$path = str_replace($root, '', $root);

	$exp = array();
	if (isset($_GET['p'])) {
		$_GET['p'] = str_replace('..', '', $_GET['p']);
		
		$_GET['p'] = trim($_GET['p'], '/');
		$exp = explode('/', $_GET['p']);
		$root .= '/'.$_GET['p'];
		$path .= '/'.$_GET['p'];
	}
	else {
		$root = $root;
	}
}

function getglob($path) {
	global $root, $ignore;

	$return = array();

	$content = glob($path);
	foreach ($content as $c) {
		if (is_dir($c)) {
			if (ROOT === true) {
				if (in_array($c, $ignore)) {
					continue;
				}
			}
			
			$c = str_replace($root, '', $c);
			$c = trim(str_replace($root, '', $c), '/');
			$return['folders'][] = $c;
		}
		else {
			if (ROOT === true) {
				if (in_array($c, $ignore)) {
					continue;
				}
			}
			
			$c = str_replace($root, '', $c);
			$c = trim(str_replace($root, '', $c), '/');

			if (strtolower($c) == 'index.php' || strtolower($c) == 'index.html' || strtolower($c) == 'index.htm') {
				$return['index'] = $c;
			}
			
			if (strtolower($c) == 'readme.md' || strtolower($c) == 'readme.txt') {
				$return['readme'] = $root.'/'.$c;
				
			}
			
			$return['files'][] = $c;
		}
	}
	return $return;
}
