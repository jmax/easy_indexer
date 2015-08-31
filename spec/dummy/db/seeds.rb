Post.delete_all
PostsIndex.new.rebuild!

30.times do

  Post.create(
    title: "Fake title from #{('a'..'z').to_a.shuffle[0,8].join}",
    body: "Fake body text from #{('a'..'z').to_a.shuffle[0,8].join}",
    published: [true,false].sample
  )

  printf "."

end
printf "\n"
puts "Done!"
