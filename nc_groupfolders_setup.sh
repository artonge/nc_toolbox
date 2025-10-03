git -C apps-extra/groupfolders checkout v18.1.4
rm -rf data2
nc_reset_instance stable30 stable30 -a groupfolders -o

occ group:add G1
occ group:adduser G1 admin

occ groupfolders:create GF1
occ groupfolders:group 1 G1 read write share delete
curl -k https://nextcloud-stable30.test/remote.php/dav/files/admin/GF1/test.txt -u admin:password -T - <<< "Hello World"

occ config:system:set datadirectory --value="$(pwd)/data2"
mv data data2

occ groupfolders:create GF2
occ groupfolders:group 2 G1 read write share delete
curl -k https://nextcloud-stable30.test/remote.php/dav/files/admin/GF2/test.txt -u admin:password -T - <<< "Hello World"


git -C apps-extra/groupfolders checkout v18.1.5
occ upgrade
