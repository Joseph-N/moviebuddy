ActiveAdmin.register_page "Dashboard" do
    content :title => proc{ I18n.t("active_admin.dashboard") } do

        columns do

            column do
                panel "Recent Movies" do
                    ul :class => "movies" do
                        Movie.last(15).each do |movie|
                            li link_to image_tag("http://d3gtl9l2a4fn1j.cloudfront.net/t/p/w92/#{movie.poster}"), admin_movie_path(movie)
                        end
                    end
                    strong { link_to "All Movies", admin_movies_path }
                end
            end

            column do
                panel "New Users" do
                    table_for User.order('created_at desc').limit(5) do
                        column "Avator", :avator_file_name do |user|
                            link_to image_tag(user.avator.url(:thumb)), admin_user_path(user)
                        end
                        column :name
                        column :email
                        column "Date", :current_sign_in_at
                    end
                    strong { link_to "All Users", admin_users_path }
                end
            end
        end

        columns do
            column do
                panel "Latest Updates" do
                    table_for Update.order('created_at desc').limit(10) do
                        column :content do |update|
                            update.content? ? update.content : "Added new movie"
                        end
                        column "Time", :created_at do |update|
                            "#{ time_ago_in_words update.created_at } ago"                                                    
                        end
                    end
                    strong { link_to "All Updates", admin_updates_path }
                end
            end
        end
    end # content

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
end
