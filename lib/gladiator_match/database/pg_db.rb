module GladiatorMatch
  module Database
    class PostGres
      # binding.pry
      def initialize(config = nil)
        ActiveRecord::Base.establish_connection(
          # YAML.load_file("db/config.yml")[env]
          YAML.load_file('db/config.yml')['test']
        )

      end

      def clear_everything
        User.destroy_all
        Interest.destroy_all
        Membership.destroy_all
        Group.destroy_all
        Session.destroy_all
        Invite.destroy_all
      end

      class User < ActiveRecord::Base
        has_many :groups, :through => :memberships
        has_many :memberships
        has_many :interests, :through => :user_interests
        has_many :user_interests
      end

      class Membership < ActiveRecord::Base
        belongs_to :user
        belongs_to :group
      end

      class Group < ActiveRecord::Base
        has_many :users, :through => :memberships
        has_many :memberships
        has_many :invites
      end

      class Session < ActiveRecord::Base
      end

      # should there be some relationship with users
      # even though interest only has two columns for user ids
      class Invite < ActiveRecord::Base
        belongs_to :group
      end

      class UserInterest < ActiveRecord::Base
        belongs_to :user
        belongs_to :interest
      end

      class Interest < ActiveRecord::Base
        has_many :users, :through => :user_interests
        has_many :user_interests
      end

      def create_user(attrs)
        # ensure we only use these attributes to create the AR object
        ar_attrs = attrs.slice(:first_name, :last_name, :email, :github_login, :remote, :latitude, :longitude, :github_id)

        ar_user = User.create(ar_attrs)

        attrs.merge!(ar_user.attributes)

        entity_user = GladiatorMatch::User.new(attrs)

        if attrs[:interests]
          attrs[:interests].each do |interest|
            ar_interest = Interest.find(interest.id)

            UserInterest.create(user_id: ar_user.id, interest_id: ar_interest.id)
          end
        end

        # binding.pry
        # for some reason this code causes rspec to stall - interesting
        # if attrs[:interests]
        #   attrs[:interests].each do |interest|
        #     entity_user.interests << Interest.find(interest.id)
        #   end
        # end

        entity_user
      end

      def get_user(uid, groups: false)
        ar_user = User.find(uid)
        entity_user = GladiatorMatch::User.new(ar_user.attributes)

        if groups
          entity_user.groups = ar_user.groups
        end
        # binding.pry
        entity_user.interests = ar_user.interests.map do |interest|
          GladiatorMatch::Interest.new(interest.attributes)
        end

        entity_user
      end

      def all_users
        ar_users = User.all
        ar_users.map { |ar_user| User.new(ar_user.attributes) }
      end

      def get_user_by_login(github_login)
        ar_user = User.where(github_login: github_login).first
        entity_user = GladiatorMatch::User.new(ar_user.attributes)
        entity_user.groups = ar_user.groups
        entity_user
      end

      def get_user_by_session(sid)
        ar_session = Session.where(session_key: sid).first
        ar_user = User.find(ar_session.user_id)
        entity_user = get_user(ar_user.id, groups: true)
      end

      def get_user_by_email(email)
        ar_user = User.where(email: email)[0]
        entity_user = GladiatorMatch::User.new(ar_user.attributes)
        entity_user.groups = ar_user.groups
        entity_user
      end

      def get_user_by_github_id(github_id)
        ar_user = User.where(github_id: github_id)[0]
        entity_user = GladiatorMatch::User.new(ar_user.attributes)
        entity_user.groups = ar_user.groups
        entity_user
      end
      # # # # #
      # Group #
      # # # # #

      def create_group(attrs)
        # AR Group created with default topic
        if attrs[:topic]
          ar_group = Group.create(topic: attrs[:topic])
        else
          ar_group = Group.create(topic: "Introduce Yourselves")
        end
        attrs[:users].each do |user|
          # .instance_values turns attributes of object into a hash
          # similar to doing .attributes on AR obj
          Membership.create(group_id: ar_group.id, user_id: user.id)
        end

        entity_group = GladiatorMatch::Group.new(ar_group.attributes)
        entity_group.users = attrs[:users]
        entity_group
      end

      def get_group(gid, users: false)
        ar_group = Group.find(gid)
        entity_group = Group.new(ar_group.attributes)
        if users
          entity_group.users = ar_group.users
        end
        entity_group
      end

      # # # # # #
      # Invite  #
      # # # # # #

      def create_invite(attrs)
        ar_invite = Invite.create(attrs)
        entity_invite = GladiatorMatch::Invite.new(ar_invite.attributes)
      end

      def get_invite(iid)
        ar_invite = Invite.find(iid)
        entity_invite = GladiatorMatch::Invite.new(ar_invite.attributes)
      end

      def update_invite(updated_invite)
        ar_invite = Invite.find(updated_invite.id)

        # a hash with string keys
        updated_invite_attrs = updated_invite.instance_values

        updated_invite_attrs.each do |attr, value|
          setter = (attr + "=").to_sym
          ar_invite.send(setter, value)
        end

        ar_invite.save

        Invite.new(updated_invite_attrs)
      end

      # # # # #  #
      # Interest #
      # # # # #  #

      def create_interest(attrs)
        ar_interest = Interest.create(attrs)
        entity_interest = GladiatorMatch::Interest.new(ar_interest.attributes)
      end

      def get_interest(iid)
        ar_interest = Interest.find(iid)
        entity_interest = GladiatorMatch::Interest.new(ar_interest.attributes)
      end

      # # # # #  #
      # Session ##
      # # # # #  #

      def create_session(attrs)
        # generate unique crazy id for session
        sid = SecureRandom.uuid
        ar_session = Session.create(session_key: sid, user_id: attrs[:user_id])
        sid
      end

      def get_session(skey)
        ar_session = Session.where(session_key: skey).first
        # may need to change :id to :skey for both here and inmemory db
        { id: ar_session.session_key, user_id: ar_session.user_id }
      end

      # # # # #  #
      # Queries ##
      # # # # #  #

      def get_users_by_group(gid)
        ar_users = Group.find(gid).users
        ar_users.map { |ar_user| GladiatorMatch::User.new(ar_user.attributes) }
      end

      def get_groups_by_user(uid)
        ar_groups = User.find(uid).groups
        ar_groups.map { |ar_group| GladiatorMatch::Group.new(ar_group.attributes) }
      end
    end
  end
end