# Parameter Sets

Parameter Sets allows you to use a simple schema that defines which attributes are permitted to be mass assigned to Active Model objects. The key goals of the library are:

* To standardize a method of defining which attributes are permitted for mass assignment.
* To allow the permitted attributes to be easily adjusted based on the request (for example the logged in user).
* To allow the permitted attributes to be easily adjusted based on the state of the model they are being applied to.

## Installation

To start using this library, you just need to add the gem to your Gemfile and run `bundle`.

```ruby
gem 'parameter_sets'
```

## Usage

Here's an example of how this library can be used in its most basic form.

```ruby
class BlogPostsController < ApplicationController

  param_set :blog_post do |r|
    # Always permit the title & content to be set by anyone
    r.permit :title, :content

    # Only allow admin users to change the author of the blog post
    if current_user.admin?
      r.permit :author_id
    end
  end

  def update
    @blog_post.update(param_set(:blog_post))
    @blog_post.save!
  end

end
```

### Defining parameter sets

The basic principle of this pattern allows you to define a parameter set within a controller. It replaces the usual pattern of using a `post_params` or `safe_params` instance method on the controller and adds some syntactic sugar around how to access the parameters.

Parameter sets are defined on a controller as shown in the example above. Each parameter set as a name which is the same name as that will be provided in the parameters themselves. For example, if you're submitting attributes like `post[title]`, the name should match the first part of the parameter (`post`).

The code below demonstrates all the options available when working with a param set.

```ruby
param_set :blog_post do |r, object, options|

  # This is the most simple way to permit an attribute
  r.permit :title

  # You can also pass multiple attributes to the permit method if needed
  r.permit :title, :content, :excerpt

  # Everything inside this block is evaluated int he context of the request
  # that the params are being used within. This gives you access to make
  # decisions based on other variables.
  if logged_in? && current_user.admin?
    # Only permit the author_id attribute if logged in as an admin user
    r.permit :author_id
  end

  # Depending on how you access your parameters, you may also have access to
  # the object that the param set relates to.
  if object && object.persisted?
    # Only allow permalinsk to be changed if the object has been saved
    r.permit :permalink
  end

  # You can permit different types of attributes too if needed (the same as
  # is used with normal permits)
  r.permit :tags, []

  # Finally, you'll have access to any options that are passed when generating
  # the parameters
  if options[:allow_passwords]
    r.permit :password
  end

end
```

### Accessing safe parameters

Once you've defined your parameter sets, you can use the methods within your controller to access parameters.

```ruby
# Return all safe parameters for a given param set
param_set(:blog_post)

# Return all safe parameters for a given param set with an object
param_set(:blog_post, @blog_post)

# Return all safe parameters for a given param set with an object & options
param_set(:blog_post, @blog_post, :allow_passwords => true)

# Return all safe parameters for a given object. The name will be determined
# automatically based on the model name (BlogPost -> blog_post etc...)
param_set(@blog_post)
```

In practice, you'll find that your controllers may look a little like this.

```ruby
def create
  @blog_post = BlogPost.new(param_set(:blog_post))
  # You'll find this instance, you don't have access to any `object` within the
  # param set because none exists when the method was called.
  if @blog_post.save
    redirect_to @blog_post
  end
end

def update
  if @blog_post.update(param_set_for(@blog_post))
    redirect_to @blog_post
  end
end
```
