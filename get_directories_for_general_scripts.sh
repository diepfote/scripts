user=`cut -d : -f 1 /etc/passwd | grep flo`
user_dir=/home/$user

dir=$user_dir/Documents

if [ ! -d $dir ]; then
  dir=$user_dir/Docs
fi

passwd_dir=$dir/passwds

if [ ! -d $passwd_dir ];then
  passwd_dir=$user_dir/Dokumente/passwds
fi

echo $user_dir $dir $passwd_dir
