xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  xml.url do
    xml.loc "http://ruby.mk"
    xml.priority 1.0
  end

  @tags.each do |tag|
    xml.url do
      xml.loc tag_posts_url(tag.name)
      xml.priority 0.9
    end
  end

  @posts.each do |post|
    xml.url do
      xml.loc post_url(post)
      xml.lastmod post.updated_at.to_date
      xml.priority 0.9
    end
  end

end
