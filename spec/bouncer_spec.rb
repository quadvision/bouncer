require 'spec_helper'
include Bouncer::AccessHelper


describe Bouncer::AccessHelper do
  describe '#can_access?' do
    before do
      Bouncer.config = {
        'authorization_profiles' =>
          ['admin', 'access1', 'access2'],

        'authorizations' =>
          {
            'somenamespace' => {
              'authorized_profiles' => ['admin', 'access1'],
              'somecontroller' => {
                'edit' => {
                  'authorized_profiles' => ['admin']
                },
                'update' => {
                  'authorized_profiles' => ['admin']
                }
              }
            },
            'other_namespace' => {
              'authorized_profiles' => ['admin', 'access1', 'access2'],
              'othercontroller' => {
                'authorized_profiles' => ['admin', 'access1'],
                'new' => {
                  'authorized_profiles' => ['access1, admin', 'access2']
                },
                'create' => {
                  'authorized_profiles' => ['access1, admin']
                }
              }
            }


          }
      }
      @user = Object.new
    end

    describe 'admin access' do
      before do
        def @user.authorization_profile_key
          'admin'
        end
      end

      describe 'accessible path' do
        it 'should allow access to all paths' do
          expect(can_access?('welcome/index')).to be_truthy
          expect(can_access?('somenamespace')).to be_truthy
          expect(can_access?('somenamespace/somecontroller/edit')).to be_truthy
        end
      end
    end

    describe 'access1 access' do
      before do
        def @user.authorization_profile_key
          'access1'
        end
      end

      it 'should allow access to allowed paths' do
        expect(can_access?('welcome/index')).to be_truthy
        expect(can_access?('somenamespace')).to be_truthy
        expect(can_access?('somenamespace/somecontroller/index')).to be_truthy
        expect(can_access?('othernamespace/othercontroller/new')).to be_truthy
      end

      it 'should not allow access to blocked paths' do
        expect(can_access?('somenamespace/somecontroller/edit')).not_to be_truthy
        expect(can_access?('somenamespace/somecontroller/update')).not_to be_truthy
      end
    end

    describe 'access2 access' do
      before do
        def @user.authorization_profile_key
          'access2'
        end
      end

      it 'should allow access to allowed paths' do
        expect(can_access?('other_namespace')).to be_truthy
      end

      it 'should not allow access to blocked paths, first blockage stops access' do
        expect(can_access?('other_namespace/othercontroller')).not_to be_truthy
        # Even if access2 is allowed to access this action, since it has been blocked at 'other_namespace/othercontroller' it cannot access it.
        expect(can_access?('other_namespace/othercontroller/new')).not_to be_truthy
      end
    end

  end

end

