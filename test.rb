STDOUT.sync = true

require "minitest/autorun"
require "minitest/mock"

require_relative "lib/directlink"
DirectLink.silent = true
describe DirectLink do

  describe "methods" do

    describe "google" do
      "
           1 //1.bp.blogspot.com/-rYk_u-qROQc/WngolJ8M0LI/AAAAAAAAD-w/woivnaIVzasBPG5C2T1t-VrWKRd_U6lMgCLcBGAs/w530-h278-p/i-469.jpg
           2 //4.bp.blogspot.com/-1RlHbRShONs/Wngp9WfxbfI/AAAAAAAAD-8/vnBBXpSZdvUMz4VjJPBpprLBrJ5QpBaqACLcBGAs/w530-h278-p/i-468.jpg
           3 //4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/ZbbZWs0-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/w530-h278-p/IMG_20171223_093922.jpg
           4 //4.bp.blogspot.com/-bS1SZxFkvek/Wnjz3D5Il4I/AAAAAAAAD_I/bKYvRLGB7r4NGJ0aR1F-ugsbVm4HUjf5ACLcBGAs/w530-h278-p/i-466.jpg
           5 //lh3.googleusercontent.com/-1CF2jge1MYI/Wmr_kfCQQUI/AAAAAAAClKs/N1F2tz4v0q0i5N7rgso6G8SrhJNzsHEagCJoC/w530-h352-p/2809525%2B%25D0%2593%25D0%2590%25D0%259B%25D0%259E%2B%25D0%259F%25D0%2590%25D0%25A0%25D0%2593%25D0%2595%25D0%259B%25D0%2598%25D0%2599%2B-%2B%25D0%25A7%25D0%25A3%25D0%259A%25D0%259E%25D0%25A2%25D0%259A%25D0%2590%2B-%2B%25D0%25AE%25D0%25A0%25D0%2598%25D0%2599%2B%25D0%25A5%25D0%2590%25D0%25A0%25D0%25A7%25D0%2595%25D0%259D%25D0%259A%25D0%259E.jpg
           6 //lh3.googleusercontent.com/-h1siEcRFqJ8/Wiv1iDQhNVI/AAAAAAAAQV4/9gGepSmYkDMLyVTG_1EBCMmj-UhmclXWwCJoC/w530-h353-p/001
           7 //lh3.googleusercontent.com/-qnZygRb-Tn8/Wlyj4UuKbaI/AAAAAAAATqE/iKWSto-XBZwsh843xJ3cSd0JPt1LedU9gCJoC/w530-h330-p/001
           8 //lh3.googleusercontent.com/-rXO9PzbjNmk/WlNfjJkJBmI/AAAAAAAATNY/4dHLtYtWBzUKWufNXWkK82etw3RKA6jVgCJoC/w530-h361-p/001

          13 //lh3.googleusercontent.com/proxy/2fsWfEOeeCMNEP8MGvHiJPkBlg47Ifaf8DwpgDPJSPSYsh9iomTrfOA9OuwB60laZimtNr4-1GKA5J2csuVB6-1DLNO30K-fngB8p56ivICWRFAUuOwzizaztBx5gQ=w530-h707-p
          14 //lh3.googleusercontent.com/proxy/2qy3gOwhBT77Ie_qa9VgGz6kgN14tnOh1AMmV9FB65oiXOSAIll1_qmOZdupL3QCcJQL4701YskEgeDUnxJTnFGq4mFEzNFvjpNC-QMX9Jg7mdar3e89u_siA4AD-j1SJ6mrkl2MwSJSu1s2guYn0NR5ND1985lK34_iGiwzjoGHG2a65IbxKDSEzgSGbPQ_CQiQ6rBIvfcgvAxtS6E=s530-p
          28 //lh3.googleusercontent.com/proxy/7N0QCidzIFysO6OhmrG8twRJ74-sboNenI3Nhy3mIWP8C0SSa8J6xFQU3iyBTw4k3QeleiAgXOME3abYutPvBrHGx-0TBUcI-_LsgFa59Zaw6PAGdLndkxp5ReRJnsg=w530-h298-p
          31 //lh3.googleusercontent.com/proxy/7pN3aTE159nEXXQb_KajU1vcnDDzJVpGOv9vlWWPd3CbVuCKu-v4ndr423Mmhx-Zn5vqkVf6-TfZgPA5NyHECsr4w7kaw1jTmQDJbWO-9jU-Cs7ywrzcIRhyYTTZT-hPGiazwI1oEdbooIk=w464-h640-p
          48 //lh3.googleusercontent.com/proxy/DZtTi5KL7PqiBwJc8weNGLk_Wi2UTaQH0AC_h2kuURiu0AbwyI2ywOk2XgdAjL7ceg=w530-h354-n
          74 //lh3.googleusercontent.com/proxy/P4FQdTYwWN8cU_PWmFja1cm3oYu57L_flea7LmKvFjx0Ibdxl3glxcp-KFWsdRxMFTQ3gQkWsWzlrkyCm9QrSjCUcGIgnbsYBCXewnhEwSn0ZgT4XDg485GdXMoGWpNETrLYa8IGvG20_iw=w504-h597-p
         137 //lh3.googleusercontent.com/proxy/kX1ABK6_VjHDU12p-zZN6ciTOzqFcXm7IV41uR9F2sveM2t148nmWBEN1clA-VHvowpkd9T4NOPrAfDaip1o-jJBtBnRBElJuCsKo8FviSIkToZWCY9nQFEj06nHkMNuReBtdbVBlIRSodNJM-_cmqiJ-DnmWNe4dk62EF_kGLS28OWmckDLWVG0YFiZ-lVi8JhgR-ZgRmYWTs8bb_u6v6ucgfo8eh7ewchuZAD9_CoxUlQChAqz0QIfuVuKvmcXE06Ylv2H330btswQotjKDf8AXPe6xcyE9X1JXDYQTsPv-7lftLG9WQp1Mlc9Wu1XbHV7f541L-smt--7YpkW6fbDFYk4_87-pIOcg9UqHKB__DWyMCtH3gs8rv6VCmVwL1a-oAeBWSWk0Tc9R6uSuyCjt0nEBGlZY35aW1Pchz0jXr4lq8Il9m-wbRN9E7Kff1JR89YFOrV2N86w_72YTefFerLFfEsgzmhx3WYwok-4H12RdH7MyiHBQt04uRnb58GA4vl5VBQ=w530-h398-p

         245 https://lh3.googleusercontent.com/-2JzV0ErXvv8/Wsdr-m5Q_aI/AAAAAAAA_-I/Lw_e6qEMPUck4yW9yWhkC-nBNd5em8c3QCJoC/w530-h795-n/888052_800n.jpg
         346 https://lh3.googleusercontent.com/-8YmBt-SUaJo/War0Un_7YTI/AAAAAAAB9xs/kgXp9QrHZX8mpDfyLwuS9cvUSsXIoH6NgCL0BGAs/w530-d-h443-n/%25D0%259B%25D0%25B5%25D1%2581%2B%25D0%25BD%25D0%25B0%2B%25D0%25B8%25D1%2581%25D1%2585%25D0%25BE%25D0%25B4%25D0%25B5%2B%25D0%25BB%25D0%25B5%25D1%2582%25D0%25B0.JPG
        1317 https://lh3.googleusercontent.com/-tGAyJv4S6gM/WSLy4A7AFaI/AAAAAAABxk4/eq0Aprp2koM6GEti9xEIn-0PLh87bRRdQCL0B/w530-d-h660-n/%25D0%2592%25D0%25B5%25D1%2581%25D0%25BD%25D1%258B%2B%25D1%2586%25D0%25B2%25D0%25B5%25D1%2582%25D0%25B5%25D0%25BD%25D0%25B8%25D0%25B5.JPG

         178 https://lh3.googleusercontent.com/--Ggbfs9HJZM/Wog1DA2WcFI/AAAAAAAAbdQ/SZKPcnXFIr8MFfl9pddfiLPQnOiJ37muQCJoC/w409-h727-n/11a1c54f37c07d3c04588b40d108b4c2.jpg
         260 https://lh3.googleusercontent.com/-3Fe6CL9RH4o/WnipWY4889I/AAAAAAAAI4I/CPqdKpjqdlwkaBlCqGQ3RdZ9bLJ4nzBwwCJoC/w239-h318-n/gplus1855963830.jpg
         303 https://lh3.googleusercontent.com/-5vPhLnUILsA/WqFhJhu7VlI/AAAAAAAAAhQ/wWSrC8dqZTA7OuzeU3UoXJkNG19tqtAGwCJoC/w265-h353-n/DSC08260.JPG
         668 https://lh3.googleusercontent.com/-NLW68hNxEzU/WrSNfBxFX2I/AAAAAAAAAT8/7cvRM-DUZLoIdlb6CS8pL5-eJ3wbwohlQCJoC/w179-h318-n/23.03.2018%2B-%2B3
         669 https://lh3.googleusercontent.com/-NVJgqmI_2Is/WqMM2OMYg-I/AAAAAAAALrk/5-p3JL3iZt0Ho9dOf_p3gpddzqwr3Wp0ACJoC/w424-h318-n/001
         783 https://lh3.googleusercontent.com/-SqAvt_F__bg/Wq0huHcX2NI/AAAAAAAAVj0/XfnwCU7JwhUh0Knw8rcXA-bhpKYkI4hdwCJoC/w358-h318-n/IMG_20180317_120218-01-01.jpeg
         830 https://lh3.googleusercontent.com/-VB3YlLVL_tQ/Wo21yTbKl_I/AAAAAAAAApU/3DURmsYBklcv0kif2ZRjhoLG4mTHYf8OwCJoC/w254-h318-n/180218_00001.jpg
        1002 https://lh3.googleusercontent.com/-d8FkfLWq-_4/WpQXzEfFgBI/AAAAAAAADww/J32xKSAYUkgIc3pyrZnNmRec6kjdnJBHgCJoC/w239-h318-n/gplus-485739203.jpg
      ".scan(/(\S+) (\S+)/).each do |i, url|
        it "##{i}" do
          assert_kind_of String, DirectLink.google(url)
        end
      end
    end

    describe "imgur" do
      %w{
        https://imgur.com/a/badlinkpattern
        http://example.com/
        https://imgur.com/gallery/YO49F.
      }.each_with_index do |url, i|
        it "ErrorBadLink_##{i + 1}" do
          assert_raises DirectLink::ErrorBadLink do
            DirectLink.imgur url
          end
        end
      end

      valid_imgur_image_url = "https://i.imgur.com/BLCesav.jpg"
      it 200 do
        assert_equal [["https://i.imgur.com/BLCesav.jpg", 1000, 1500, "image/jpeg"]],
                     DirectLink.imgur(valid_imgur_image_url)
      end
      it 404 do
        assert_raises DirectLink::ErrorNotFound do
          NetHTTPUtils.stub :request_data, ->*{ raise NetHTTPUtils::Error.new "", 404 } do
            DirectLink.imgur valid_imgur_image_url
          end
        end
      end
      it 400 do
        e = assert_raises DirectLink::ErrorAssert do
          NetHTTPUtils.stub :request_data, ->*{ raise NetHTTPUtils::Error.new "", 400 } do
            DirectLink.imgur valid_imgur_image_url
          end
        end
        assert_equal 400, e.cause.code if Exception.instance_methods.include? :cause  # Ruby 2.1
      end

      [ # TODO: move these end line comments to test names; and do the same in other tests
        ["https://imgur.com/a/Aoh6l", "https://i.imgur.com/BLCesav.jpg", 1000, 1500, "image/jpeg"],
        ["http://i.imgur.com/7xcxxkR.gifv", "http://i.imgur.com/7xcxxkRh.gif", 718, 404, "image/gif"],
        ["https://imgur.com/9yaMdJq", "https://i.imgur.com/9yaMdJq.mp4", 720, 404, "video/mp4"],
        ["http://imgur.com/gallery/dCQprEq/new", "https://i.imgur.com/dCQprEq.jpg"],
        ["http://imgur.com/HQHBBBD", "https://i.imgur.com/HQHBBBD.jpg"], # http
        ["https://imgur.com/BGDh6eu", "https://i.imgur.com/BGDh6eu.jpg"], # https
        ["https://imgur.com/a/qNCOo", 6, "https://i.imgur.com/vwqfi3s.jpg", "https://i.imgur.com/CnSMWvo.jpg"], # https album
        ["http://imgur.com/a/0MiUo", 49, "https://i.imgur.com/kJ1jrjO.jpg", "https://i.imgur.com/TMQJARX.jpg"], # album, zoomable
        ["http://imgur.com/a/WswMg", 20, "https://i.imgur.com/Bt3RWV7.png", "https://i.imgur.com/sRc2lqN.png"], # album image, not zoomable
        ["http://imgur.com/a/AdJUK", 3, "https://i.imgur.com/Yunpxnx.jpg", "https://i.imgur.com/2epn2nT.jpg"], # needs https because of authorship # WAT?
        ["http://imgur.com/gallery/vR4Am", 7, "https://i.imgur.com/yuUQI25.jpg", "https://i.imgur.com/RdxyAMQ.jpg"],
        ["http://imgur.com/gallery/qP2RQtL", "https://i.imgur.com/qP2RQtL.png"], # single image gallery?
        ["http://imgur.com/gallery/jm0OKQM", "https://i.imgur.com/jm0OKQM.gif"],
        ["http://imgur.com/gallery/nKAwE/new", 28, "https://i.imgur.com/VQhR8hB.jpg", "https://i.imgur.com/axlzNRL.jpg"],
        ["http://m.imgur.com/rarOohr", "https://i.imgur.com/rarOohr.jpg"],
        ["http://imgur.com/r/wallpaper/j39dKMi", "https://i.imgur.com/j39dKMi.jpg"],
        ["http://imgur.com/gallery/oZXfZ", 12, "https://i.imgur.com/t7RjRXU.jpg", "https://i.imgur.com/anlPrvS.jpg"],
        ["http://imgur.com/gallery/dCQprEq/new", "https://i.imgur.com/dCQprEq.jpg", 5760, 3840, "image/jpeg"],
        ["https://imgur.com/S5u2xRB?third_party=1#_=_", "https://i.imgur.com/S5u2xRB.jpg", 2448, 2448, "image/jpeg"],
        ["https://imgur.com/3eThW", "https://i.imgur.com/3eThW.jpg", 2560, 1600, "image/jpeg"],
        ["https://i.imgur.com/RGO6i.mp4", "https://i.imgur.com/RGO6i.gif", 339, 397, "image/gif"],
        # some other tests not sure we need them
        ["http://i.imgur.com/7xcxxkR.gifv", "http://i.imgur.com/7xcxxkRh.gif"],
        ["http://imgur.com/HQHBBBD", "https://i.imgur.com/HQHBBBD.jpg", 1024, 768, "image/jpeg"],
        ["http://imgur.com/a/AdJUK", 3, "https://i.imgur.com/Yunpxnx.jpg", "https://i.imgur.com/2epn2nT.jpg", "https://i.imgur.com/3afw2aF.jpg"],
        ["https://imgur.com/9yaMdJq", "https://i.imgur.com/9yaMdJq.mp4", 720, 404, "video/mp4"],
        ["http://imgur.com/gallery/dCQprEq/new", "https://i.imgur.com/dCQprEq.jpg", 5760, 3840, "image/jpeg"],
      ].each_with_index do |t, i|
        url, n, first, last, type = t
        it "##{i + 1}" do
          real = DirectLink::imgur url
          case last
          when NilClass
            assert_equal 1, real.size
            assert_equal n, real.first.first
          when Numeric
            assert_equal 1, real.size
            assert_equal [n, first, last, type], real.first
          when String
            assert_equal n, real.size
            assert_equal first, real.first.first
            assert_equal last, real.last.first
          else
            fail "bug in tests"
          end
        end
      end
    end

    [
      [ :_500px, [
        ["https://500px.com/photo/112134597/milky-way-by-tom-hall", [4928, 2888, "https://drscdn.500px.org/photo/112134597/m%3D2048_k%3D1_a%3D1/v2?client_application_id=48351&webp=true&sig=6b9f6ac5aed6d051aa66911555657ef57262e7d998f406e40f50e6f61515808f", "jpeg"]],
      ] ],
      [ :flickr, [
        ["https://www.flickr.com/photos/tomas-/17220613278/", DirectLink::ErrorNotFound],
        ["https://www.flickr.com/photos/16936123@N07/18835195572", DirectLink::ErrorNotFound],
        ["https://www.flickr.com/photos/44133687@N00/17380073505/", [3000, 2000, "https://farm8.staticflickr.com/7757/17380073505_ed5178cc6a_o.jpg"]],                            # trailing slash
        ["https://www.flickr.com/photos/jacob_schmidt/18414267018/in/album-72157654235845651/", DirectLink::ErrorNotFound],                                                       # username in-album
        ["https://www.flickr.com/photos/tommygi/5291099420/in/dateposted-public/", [1600, 1062, "https://farm6.staticflickr.com/5249/5291099420_3bf8f43326_o.jpg"]],              # username in-public
        ["https://www.flickr.com/photos/132249412@N02/18593786659/in/album-72157654521569061/", DirectLink::ErrorNotFound],
        ["https://www.flickr.com/photos/130019700@N03/18848891351/in/dateposted-public/", [4621, 3081, "https://farm4.staticflickr.com/3796/18848891351_f751b35aeb_o.jpg"]],      # userid   in-public
        ["https://www.flickr.com/photos/frank3/3778768209/in/photolist-6KVb92-eCDTCr-ur8K-7qbL5z-c71afh-c6YvXW-7mHG2L-c71ak9-c71aTq-c71azf-c71aq5-ur8Q-6F6YkR-eCDZsD-eCEakg-eCE6DK-4ymYku-7ubEt-51rUuc-buujQE-ur8x-9fuNu7-6uVeiK-qrmcC6-ur8D-eCEbei-eCDY9P-eCEhCk-eCE5a2-eCH457-eCHrcq-eCEdZ4-eCH6Sd-c71b5o-c71auE-eCHa8m-eCDSbz-eCH1dC-eCEg3v-7JZ4rh-9KwxYL-6KV9yR-9tUSbU-p4UKp7-eCHfwS-6KVbAH-5FrdbP-eeQ39v-eeQ1UR-4jHAGN", [1024, 681, "https://farm3.staticflickr.com/2499/3778768209_280f82abab_b.jpg"]],
        ["https://www.flickr.com/photos/patricksloan/18230541413/sizes/l", [2048, 491, "https://farm6.staticflickr.com/5572/18230541413_fec4783d79_k.jpg"]],
        ["https://flic.kr/p/vPvCWJ", [2048, 1365, "https://farm1.staticflickr.com/507/19572004110_d44d1b4ead_k.jpg"]],
      ] ],
      [ :wiki, [
        ["https://en.wikipedia.org/wiki/Prostitution_by_country#/media/File:Prostitution_laws_of_the_world.PNG", "https://upload.wikimedia.org/wikipedia/commons/e/e8/Prostitution_laws_of_the_world.PNG"],
        ["https://en.wikipedia.org/wiki/Third_Party_System#/media/File:United_States_presidential_election_results,_1876-1892.svg", DirectLink::ErrorAssert],
        ["http://commons.wikimedia.org/wiki/File:Eduard_Bohlen_anagoria.jpg", "https://upload.wikimedia.org/wikipedia/commons/0/0d/Eduard_Bohlen_anagoria.jpg"],
      ] ],
    ].each do |method, tests|
      describe method do
        tests.each_with_index do |(input, expectation), i|
          it "##{i + 1}" do
            if expectation.is_a? Class
              assert_raises expectation do
                DirectLink.method(method).call input
              end
            else
              result = DirectLink.method(method).call input
              assert_equal expectation, result, "#{input} :: #{result.inspect} != #{expectation.inspect}"
            end
          end
        end
      end
    end

    {
      google: %w{
        https://lh3.googleusercontent.com/-NVJgqmI_2Is/WqMM2OMYg-I/AAAAAAAALrk/5-p3JL3iZt0Ho9dOf_p3gpddzqwr3Wp0ACJoC/w424-h318-n/001
        https://lh3.googleusercontent.com/-2JzV0ErXvv8/Wsdr-m5Q_aI/AAAAAAAA_-I/Lw_e6qEMPUck4yW9yWhkC-nBNd5em8c3QCJoC/w530-h795-n/888052_800n.jpg
        //lh3.googleusercontent.com/proxy/DZtTi5KL7PqiBwJc8weNGLk_Wi2UTaQH0AC_h2kuURiu0AbwyI2ywOk2XgdAjL7ceg=w530-h354-n
        //lh3.googleusercontent.com/-h1siEcRFqJ8/Wiv1iDQhNVI/AAAAAAAAQV4/9gGepSmYkDMLyVTG_1EBCMmj-UhmclXWwCJoC/w530-h353-p/001
        //1.bp.blogspot.com/-rYk_u-qROQc/WngolJ8M0LI/AAAAAAAAD-w/woivnaIVzasBPG5C2T1t-VrWKRd_U6lMgCLcBGAs/w530-h278-p/i-469.jpg
      },
      imgur: %w{
        https://imgur.com/3eThW
      },
      _500px: %w{
        https://500px.com/photo/112134597/milky-way-by-tom-hall
      },
      flickr: %w{
        https://www.flickr.com/photos/tomas-/17220613278/
        https://flic.kr/p/vPvCWJ
      },
      wiki: %w{
        https://en.wikipedia.org/wiki/Third_Party_System#/media/File:United_States_presidential_election_results,_1876-1892.svg
        http://commons.wikimedia.org/wiki/File:Eduard_Bohlen_anagoria.jpg
      },
    }.each do |method, tests|
      describe "DirectLink() calls #{method}" do
        tests.each_with_index do |input, i|
          it "##{i + 1}" do
            called = false
            m = DirectLink.method method
            DirectLink.stub method, ->link{ called = true } do
              DirectLink.method(method).call input
              assert called, "DirectLink::#{method} was not called"
            end
          end
        end
      end
    end

  end

  describe "DirectLink()" do

    describe "throws ErrorBadLink if method does not match the link" do
      %i{ google imgur flickr _500px wiki }.each do |method|
        it method do
          assert_raises DirectLink::ErrorBadLink do
            DirectLink.method(method).call ""
          end
        end
      end
    end

    describe "does not shadow the internal exception" do
      [
        [:google, "//lh3.googleusercontent.com/proxy/DZtTi5KL7PqiBwJc8weNGLk_Wi2UTaQH0AC_h2kuURiu0AbwyI2ywOk2XgdAjL7ceg=w530-h354-n"],
        [:imgur, "http://imgur.com/HQHBBBD"],
        [:flickr, "https://www.flickr.com/photos/tomas-/17220613278/"],
        [:_500px, "https://500px.com/photo/112134597/milky-way-by-tom-hall"],
        [:wiki, "http://commons.wikimedia.org/wiki/File:Eduard_Bohlen_anagoria.jpg"],
      ].each do |method, link|
        it method do
          e = assert_raises DirectLink::ErrorBadLink do
            DirectLink.stub method, ->*{ raise DirectLink::ErrorBadLink.new "test" } do
              DirectLink link
            end
          end
          assert_equal "\"test\" -- if you think this link is valid, please report the issue", e.message
        end
      end
      it "raises FastImage::ImageFetchFailure on Net::HTTP failure" do
        assert_raises FastImage::ImageFetchFailure do
          NetHTTPUtils.stub :get_response, ->*{ raise SocketError.new } do
            DirectLink "http://example.com/404"
          end
        end
      end
    end

    describe "some other tests" do
      [
        ["http://www.aeronautica.difesa.it/organizzazione/REPARTI/divolo/PublishingImages/6%C2%B0%20Stormo/2013-decollo%20al%20tramonto%20REX%201280.jpg", ["http://www.aeronautica.difesa.it/organizzazione/REPARTI/divolo/PublishingImages/6%C2%B0%20Stormo/2013-decollo%20al%20tramonto%20REX%201280.jpg", 1280, 853, :jpeg]],
        ["http://example.com", FastImage::UnknownImageType],              # was URL2Dimensions::ErrorUnknown
        ["http://minus.com/lkP3hgRJd9npi", FastImage::ImageFetchFailure], # was URL2Dimensions::Error404
        ["https://i.redd.it/si758zk7r5xz.jpg", FastImage::ImageFetchFailure],                                                       # was URL2Dimensions::Error404
        ["http://www.cutehalloweencostumeideas.org/wp-content/uploads/2017/10/Niagara-Falls_04.jpg", FastImage::ImageFetchFailure], # was URL2Dimensions::Error404
      ].each_with_index do |(input, expectation), i|
        it "##{i + 1}" do
          if expectation.is_a? Class
            assert_raises expectation do
              DirectLink input
            end
          else
            u, w, h, t = expectation
            result = DirectLink input
            assert_equal DirectLink.class_variable_get(:@@directlink).new(u, w, h, t),
                         result, "#{input} :: #{result.inspect} != #{expectation.inspect}"
          end
        end
      end
    end

  end

  describe "./bin" do
    require "open3"
    # that hack around `export` is for crossplatform Travis test, since Ubuntu uses `sh` that can't `source`
    describe "fails" do
      [
        [1, "http://example.com/", "FastImage::UnknownImageType"],      # TODO: is it possible to obtain it from `.cause`?
        [1, "http://example.com/404", "FastImage::ImageFetchFailure"],
        [1, "http://imgur.com/HQHBBBD", "DirectLink::ErrorMissingEnvVar: define IMGUR_CLIENT_ID env var", " && unset IMGUR_CLIENT_ID"],  # TODO: make similar test for ./lib
        # by design it should be impossible to write a test for DirectLink::ErrorAssert
        [1, "https://flic.kr/p/DirectLinkErrorNotFound", "DirectLink::ErrorNotFound: \"https://flic.kr/p/DirectLinkErrorNotFound\""],
        [1, "https://imgur.com/a/badlinkpattern", "DirectLink::ErrorBadLink: \"https://imgur.com/a/badlinkpattern\" -- if you think this link is valid, please report the issue"],
      ].each_with_index do |(expected_exit_code, link, expected_output, unset), i|
        it "##{i + 1}" do
          string, status = Open3.capture2e "export #{File.read("api_tokens_for_travis.sh").gsub(/\n?export/, ?\s).strip}#{unset} && ruby -Ilib bin/directlink #{link}"
          assert_equal [expected_exit_code, "#{expected_output}\n"], [status.exitstatus, string]
        end
      end
    end
    valid_imgur_image_url = "https://i.imgur.com/HQHBBBD.jpg"
    [
      ["#{valid_imgur_image_url}\nimage/jpeg 1024x768\n\n#{valid_imgur_image_url}\nimage/jpeg 1024x768\n"],
      ["[\n  {\n    \"url\": \"https://i.imgur.com/HQHBBBD.jpg\",\n    \"width\": 1024,\n    \"height\": 768,\n    \"type\": \"image/jpeg\"\n  },\n  {\n    \"url\": \"https://i.imgur.com/HQHBBBD.jpg\",\n    \"width\": 1024,\n    \"height\": 768,\n    \"type\": \"image/jpeg\"\n  }\n]\n", "json"],
    ].each do |expected_output, param|
      it "#{param || "default"} succeeds" do
        string, status = Open3.capture2e "export #{File.read("api_tokens_for_travis.sh").gsub(/\n?export/, ?\s).strip} && ruby -Ilib bin/directlink#{" --#{param}" if param} #{valid_imgur_image_url} #{valid_imgur_image_url}"
        assert_equal [0, expected_output], [status.exitstatus, string]
      end
    end
  end

end
