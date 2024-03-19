<?php

$dom = new DOMDocument();

@$dom->loadHTMLFile('https://nextcloud.com/team');
$xpath = new DOMXPath($dom);
foreach ($xpath->evaluate('//h2[@class=\'teamname\']') as $member) {
	foreach ($xpath->evaluate('.//a', $member->parentNode) as $link) {
		if (preg_match('|^https?://github.com/([^/]+)/*$|', $link->getAttribute('href'), $m)) {
			printf("%30s\t%s\n", $m[1] , $member->nodeValue);
		}
	}
}
