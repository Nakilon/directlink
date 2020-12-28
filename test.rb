STDOUT.sync = true
require "pp"

require "minitest/autorun"
require "minitest/mock"

# TODO: I'm not sure it's ok that after we started using NetHTTPUtils for redirect resolving
#       we don't raise `FastImage::ImageFetchFailure` anymore in any test

fail unless ENV.include? "IMGUR_CLIENT_ID"
fail unless ENV.include? "FLICKR_API_KEY"
fail unless ENV.include? "REDDIT_SECRETS"

require_relative "lib/directlink"
DirectLink.silent = true
DirectLink.timeout = 30   # TODO: tests about this attribute

describe DirectLink do

  describe "./lib" do

    describe "google" do

      describe "does not fail" do
        # TODO: also check the #google is being called

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
      ".scan(/(\S+) (\S+)/).each do |i, link|   # some pre-May-2018 urls dump from a community
        it "Google Plus community post image ##{i}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh3.googleusercontent.com/-dUQsDY2vWuE/AAAAAAAAAAI/AAAAAAAAAAQ/wVFZagieszU/w530-h176-n/photo.jpg
        //lh3.googleusercontent.com/cOh2Nsv7EGo0QbuoKxoKZVZO_NcBzufuvPtzirMJfPmAzCzMtnEncfA7zGIDTJfkc1YZFX2MhgKnjA=w530-h398-p
        //lh3.googleusercontent.com/-0Vt5HFpPTVQ/Wnh02Jb4SFI/AAAAAAAAbCU/MtusII6-FcgxuHQWofAaWF01IBUVykMyACJoC/w530-h351-p/DSC_3804%2B-%2B%25D0%25BA%25D0%25BE%25D0%25BF%25D0%25B8%25D1%258F.JPG
        https://lh3.googleusercontent.com/-u3yxaS-b85c/WvOtHJn-DxI/AAAAAAAAAKg/A_PoO64o0VkX1erPKebiO7Xcs5Iy3idbACJoC/w424-h318-n/IMG_20180510_082023.jpg
        https://lh3.googleusercontent.com/-K2XODEFntJY/Wvl8HLwfF_I/AAAAAAAAA20/mqOtMCFuBkkvtv7jdpVkJv2XSXlOLoXVQCJoC/w212-h318-n/DPP_0006.JPG
        https://lh3.googleusercontent.com/-702a8U4EIiw/WuxqzXHQCHI/AAAAAAAABAI/rA0R2UsbxoswvH6nSePnwa5VHG2f5kNOQCJoC/w398-h318-n/Fox-Desktop-1024x1280.jpg
        https://lh3.googleusercontent.com/-YQFXT62-1OA/WvMUBWXI0PI/AAAAAAAAC60/gdtkQz9YI0knYkFB8VjC2CpKOD6-Zs6hQCJoC/w408-h318-n/%25D0%25BF%25D0%25BE%25D1%2581.jpg
        https://lh3.googleusercontent.com/--P4MRZpGk-A/WveQe_YKbAI/AAAAAAAACkQ/eTz2maXvw7A0iKoPjfuwEgfTiZS3a3HSgCJoC/w318-h318-n/gplus1165736192.jpg
        https://lh3.googleusercontent.com/-CH2N9uhwMOg/WtOxVJ1DNxI/AAAAAAAAMGs/pJf8awKJcyMFlx2g89p9_QjqlyQDmYMmACJoC/w424-h318-n/DSC03178.JPG
        https://lh3.googleusercontent.com/-NGME5H7fY1o/WtaUJCaDGmI/AAAAAAAAmBQ/jZhatiBmHPEiAAABcY2DoJ6KuzVBvqGxQCJoC/w530-h150-n/%25D0%25A1%25D0%25BD%25D0%25B8%25D0%25BC%25D0%25BE%25D0%25BA%2B%25D1%258D%25D0%25BA%25D1%2580%25D0%25B0%25D0%25BD%25D0%25B0%2B2018-04-18%2B%25D0%25B2%2B3.32.42.png
        https://lh3.googleusercontent.com/-40QwR_c58sw/WsLyS3a8uhI/AAAAAAAAAas/ojaQoF1-ZFIboOS6c5kLs7bOl_TAOU6oACJoC/w424-h318-n/271091.jpg
        https://lh3.googleusercontent.com/-XhWuVCyNBjY/WvOtHOyaj_I/AAAAAAAAAKo/gOAn__a75NwYSgaBaEBGeCTAFI9MyjqlwCJoC/w239-h318-n/IMG_20180510_081956.jpg
        https://lh3.googleusercontent.com/-R19p_rDI8mY/Wwma1oEvD6I/AAAAAAAAEX8/tQc4JOq58REEWlukw2jDCTUjH3ejGZI8gCJoC/w486-h864-n/gplus1392977354.jpg
        //2.bp.blogspot.com/-mOnRg-mkojA/W22m79XcT_I/AAAAAAAAHDs/C8yQaOA-ZeEAr3WBG--3wW8VZ5nWV0p7QCEwYBhgL/w530-h353-p/_MG_8809-Edit.jpg
      }.each_with_index do |link, i|  # March contenstants
        it "another (March) Google Plus community post image ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh3.googleusercontent.com/-mFRn677_gic/WwUz3_Www7I/AAAAAAAABio/MNYvB57tBvIl6Bxp0GsKHvg0hSyHyVWhwCJoC/w265-h353-n/IMG_20180522_210620_317.jpg
        https://lh3.googleusercontent.com/-6iAmBl21QVc/Wu4Khtduz-I/AAAAAAAAA_A/lvpwTuatrtkhL31co1n9xa7kwKEVwc6IwCJoC/w301-h318-n/gplus662578195.jpg
        https://lh3.googleusercontent.com/-NnKGFBtNG2Q/Wvt9mUDC1QI/AAAAAAAANEw/2uWvIzQmG-Y3CGHuB8-UU114z4Zr8lkLQCJoC/w530-h175-n/PANO_20180516_025747.jpg
        https://lh3.googleusercontent.com/-Q7WO7uK6_Ew/WwvJcNQ39BI/AAAAAAAABvI/xb1bdwuEZGM2SmbwamwiMmZKFOW44bhPgCJoC/w239-h318-n/DSC03627.JPG
        https://lh3.googleusercontent.com/-Uxa1I3V7WWI/Wu4Khq0IkaI/AAAAAAAAA_A/Dxs9JYJ6f6sv_7jNWMdNl3eo2jh9nYqDwCJoC/w296-h318-n/gplus-328480287.jpg
        https://lh3.googleusercontent.com/-xp3mV2iqjyo/Wu4Khr5ZKhI/AAAAAAAAA_A/725HNeKw2hYtuddakPreAkaucQR6HOYGgCJoC/w424-h318-n/20180317_085037.jpg
        https://lh3.googleusercontent.com/-oyYSEl5GABY/Wu4Khov2uGI/AAAAAAAAA_A/xFVaLt1emxUtOvys7Mw8QZIF2599lNV6ACJoC/w424-h318-n/20180317_085508.jpg
        https://lh3.googleusercontent.com/-69MIjxFjtXg/Wu4KhkZD9nI/AAAAAAAAA_A/lBHtrho7HBQgkZNztMTdR3o1RSu47OnigCJoC/w239-h318-n/gplus1795981938.jpg
        https://lh3.googleusercontent.com/-RW-U7dkkT88/Wu4Khs76OSI/AAAAAAAAA_A/2rsXBfNM4Isi3YBNWlgLnPgQpVN72dXiQCJoC/w318-h318-n/gplus-379421668.jpg
      }.each_with_index do |link, i|  # April contenstants
        it "another (April) Google Plus community post image ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh3.googleusercontent.com/-4pJI5zXoL_k/WvMUBQ6TXMI/AAAAAAAAC60/XRgJlEr5hbgKzYzOQkM8b4_fq2Yp5vNbACJoC/w239-h318-n/%25D0%25B7%25D0%25B0%25D1%2581.jpg
        https://lh3.googleusercontent.com/-NNYx8cZYF4Y/Wvl8HH7crSI/AAAAAAAAA20/0vaXtOyqDL0DLx841Gj45ePol01OCOAewCJoC/w212-h318-n/DPP_0007.JPG
        https://lh3.googleusercontent.com/-Y9zbAQDAoH8/WyCS3fapzjI/AAAAAAAAB5M/hKzS0cR0MEgnM-YJENsL7dX8Tbch5Z04wCJoC/w265-h353-n/DSC03805.JPG
        https://lh3.googleusercontent.com/-cQ1lothweSI/WvMUBS4uAJI/AAAAAAAAC60/tE7aakvztZgTqvRMcrk2FbrauU8LLhGPgCJoC/w239-h318-n/11.jpg
        https://lh3.googleusercontent.com/-Aiij3wT_v6g/WyCS3VJ-hVI/AAAAAAAAB5M/qeUFKiNXnwkJ-q2q2VoM2f9ukTqPOGhAACJoC/w265-h353-n/DSC03807.JPG
        //2.bp.blogspot.com/-hBOcNikbjOk/WwlXLbeiF9I/AAAAAAAAKKE/zT7sAlaNYIc7lTxZMY1tyND0u3UH5DuKACLcBGAs/w530-h398-p/EdnjF3yEMM8.jpg
        https://lh3.googleusercontent.com/-1_J-FT0LhUE/Wx9lWOEXUjI/AAAAAAAAB34/183rqDWZipkaSWyV6qF_Fm7_XQrtYiwdACJoC/w265-h353-n/DSC03800.JPG
        https://lh3.googleusercontent.com/-I72-Vlk3Ym4/Wx9lWLfINqI/AAAAAAAAB34/EIOySV-4ny8xMECMSC4TvHV43qUn0HLLwCJoC/w265-h353-n/DSC03797.JPG
        https://lh3.googleusercontent.com/-L-RnjWuqyuI/WxZnv-NRXWI/AAAAAAAARVw/Z3yVnOEDU7kDZ-WbRoLbEh8Tao1_DtQbACJoC/w179-h318-n/20160305_134926.jpg
        //lh3.googleusercontent.com/-7iXdrlHFM6E/WtRMPtqimXI/AAAAAAAACIo/txJyaoEvnEQu7r2-35SgwFYCWHGmXDQ3QCJoC/w530-h353-p/IMG_3695.jpg
      }.each_with_index do |link, i|  # May contenstants
        it "another (May) Google Plus community post image ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh3.googleusercontent.com/-dWul1-dnMGE/W1npdlvSenI/AAAAAAAAAJI/jHPhVr5xS98xvFJDNgMgcxrRzPd6gOp9QCJoC/w208-h318-n/alg3_1520-2.jpg
        https://lh3.googleusercontent.com/-t_ab__91ChA/VeLaObkUlgI/AAAAAAAAL4s/VjO6KK_lkRw/w530-h351-n/30.08.15%2B-%2B1
        https://lh3.googleusercontent.com/-Ry3uDLjGG0E/W13DzrEntEI/AAAAAAAAAdY/7ldMJD-2JPsnuqYq7qtif_eVWhTd0EmnwCJoC/w480-h853-n/gplus-790559743.jpg
      }.each_with_index do |link, i|  # June contenstants
        it "another (June) Google Plus community post image ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh3.googleusercontent.com/-s655sojwyvw/VcNB4YMCz-I/AAAAAAAALqo/kW98MOcJJ0g/w530-h398-n/06.08.15%2B-%2B1
        //4.bp.blogspot.com/-TuMlpg-Q1YY/W3PXkW1lkaI/AAAAAAAAHHg/Bh9IsuLV01kbctIu6lcRJHKkY-ej8oD5gCLcBGAs/w530-h353-p/_MG_2688-Edit.jpg
        //lh3.googleusercontent.com/proxy/SEfB6tFuim6X0HdZfEBSxrXtumUdf4Q4y05rUW4wc_clWWVrowuWAGZghx71xwPUmf_8si2VQwnRivsM7PfD2gp3kA=w480-h360-n
        https://lh3.googleusercontent.com/-u3FhiUTmLCY/Vk7dMQnxR2I/AAAAAAAAMc0/I76_52swA4s/w530-h322-n/Harekosh_A%252520Concert_YkRqQg.jpg
        https://lh3.googleusercontent.com/-t_ab__91ChA/VeLaObkUlgI/AAAAAAAAL4s/VjO6KK_lkRw/w530-d-h351-n/30.08.15%2B-%2B1
        //lh3.googleusercontent.com/-u2NzdIQfVyQ/Wy83AzoFT8I/AAAAAAAAh6M/fdpxOUkj5mUIfpvYol_R5dyupnF2nDIEACJoC/w530-h298-p/_DSC9134.jpg
      }.each_with_index do |link, i|  # July contenstants
        it "another (July) Google Plus community post image ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh3.googleusercontent.com/-f37xWyiyP8U/WvmxOxCd-0I/AAAAAAAACpw/3A2tRj02oY40MzJqZBJyWGImoSer0lwMgCJoC/s0/140809%2B029.jpg
        https://lh3.googleusercontent.com/-1s_eiQB4x2k/WvXQEx59z2I/AAAAAAAAcI0/DvKYzWw3g6UNelqAQdOwrdtYdSEqKgkxwCJoC/s0/001
        https://lh3.googleusercontent.com/-1Rcbffs4iRI/WvaSsRCrxJI/AAAAAAAAcJs/e-N9tmjaTCIxEBE_jXwFjiYPyZXFwh4owCJoC/s0/001
        https://lh3.googleusercontent.com/-VXUjuSl-dZY/WvK340_E9uI/AAAAAAAAVlg/HqKf1LgUcPUJNrLxHebCMuHhpDRq36_bQCJoC/s0/gplus248254159.jpg
        https://lh3.googleusercontent.com/-NlZRwcX_Lj8/WvQTijeAfJI/AAAAAAABNyo/jgoDgbZdTvsnLOGmmYlXMr2jL66ieZV4QCJoC/s0/67u8iii.png
        https://lh3.googleusercontent.com/-8baBz80pf8Y/Wu8KG5lyGhI/AAAAAAACSyU/s3hasZzObK0VlntA1EBj-WBrTRagzRnLQCJoC/s0/%25D0%2592%25D0%25B5%25D1%2581%25D0%25B5%25D0%25BD%25D0%25BD%25D0%25B8%25D0%25B5%2B%25D0%25BA%25D1%2580%25D0%25B0%25D1%2581%25D0%25B0%25D0%25B2%25D1%2586%25D1%258B.JPG
        https://lh3.googleusercontent.com/-BBjhu17YIgg/W-gnZNaZeMI/AAAAAAABA-k/UMlSbNuE0DsSEPV8u3yf_6i2S5H9vFoBgCJoC/s0/gplus320347186.png
      }.each_with_index do |link, i|
        it "already high res image ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh3.googleusercontent.com/-5USmSTZHWWI/WMi3q1GdgiI/AAAAAAAAQIA/lu9FTcUL6xMw4wdoW_I148Vm1BtF5mImwCJoC/w346-h195-n-k-no/Good%2BJob.gif
        https://lh3.googleusercontent.com/-G8eSL3Xx2Kc/WxWt9M6LptI/AAAAAAAAB_c/KNF9RBxjL04Reb3fBtwYLI2AlnLwJ9w7gCJoC/s0/20180602212016_IMG_0244.JPG
        https://lh3.googleusercontent.com/-aUVoiLNsmAg/WzcsUU2xfNI/AAAAAAAAODw/DOBual6E1rkVLHh3SKZSzbpNQzdEoZPOQCJoC/w530-h883-n-k-no/gplus-1797734754.mp4
        //lh3.googleusercontent.com/proxy/hOIoIpMEmoVDSP40VRzM92Zw2AeLvEEhxfyKHCOxiNVPyiGvZik5rMvl3jYISLgDJla6mhZuk8pFEYJhX5BU2wy_dw=w530-h822-p
        https://lh3.googleusercontent.com/-GP3BA3zGR5A/W0IwuVXlfmI/AAAAAAADROs/SH8rRlBDYTsHZiHpM45S3zpEipu5hJ2PwCJoC/s0/%25D1%2582%25D0%25B0%25D0%25B4%25D0%25B6%25D0%25B8%25D0%25BA%25D1%2581%25D0%25BA%25D0%25BE%25D0%25B5%2B%25D1%2580%25D0%25B0%25D0%25B7%25D0%25BD%25D0%25BE%25D1%2582%25D1%2580%25D0%25B0%25D0%25B2%25D1%258C%25D0%25B5.png
        https://lh3.googleusercontent.com/-DLODAbD9W7E/W27ob5XGCOI/AAAAAAADV8g/J_6RYR6UkKsc2RJOWRx6Q-NBVx5RbMoxwCJoC/s0/1236080.jpg
        https://lh3.googleusercontent.com/-cJajRreI87w/W4gW5uF4Q7I/AAAAAAADZKI/mw1YayYE-MY2-1OCCmjvgM3kbCK0lmIggCJoC/s0/2504855.jpg
        https://lh3.googleusercontent.com/-rm-m1meCOMY/W92GhExMG-I/AAAAAAADsTw/bIAm5-1CIOYEpyPJLnxT8VmI_YNW2W5dACJoC/s0/2659806_800n.jpg
        https://lh3.googleusercontent.com/-z1nwsq4NOT4/XETT5qhXP-I/AAAAAAAAC0s/03kJ22drB1EdqZ97gUXCPHkLZbbqrDbOACJoC/w530-h942-n/gplus1629127930.jpg
        https://lh3.googleusercontent.com/-NiGph3ObOPg/XE3DgnavXlI/AAAAAAABvgE/pcPPCe88rsU1r941wwP76TVf_o89i74kwCJoC/w530-h353-n/DSCF0753.JPG
        https://lh3.googleusercontent.com/-QfChCi9Lj6A/XEciVlXmDhI/AAAAAAACuZw/iYzoMIxr7SsGzEFbk1LrqIdCdWVu8zCHACJoC/w795-h1193-n-rw/z7765765765757575.jpg
      }.each_with_index do |link, i|
        it "gpluscomm_105636351696833883213_86400 ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://4.bp.blogspot.com/--L451qLtGq8/W2MiFy8SVCI/AAAAAAAARgM/9qr4fr2PiV8IE4d3zVmf5dEnlchx1V6vwCLcBGAs/w72-h72-p-k-no-nu/blood_moon_5k.jpg
        https://3.bp.blogspot.com/-aZETNznngSo/W2xbe673_6I/AAAAAAAARhs/hkXvEk85ol4SqVeZ1hI3luDGLyT4V45kACLcBGAs/w72-h72-p-k-no-nu/waterfall-1280x800-ireland-4k-19245.jpg
        https://3.bp.blogspot.com/-ZmCuJkPliO8/W3WjIWvdjXI/AAAAAAAARi4/qO9I8kzJvCMRWsgxElxzwcOCQPCyu_xDQCLcBGAs/w72-h72-p-k-no-nu/ford_mustang_neon_lights_5k.jpg
        https://2.bp.blogspot.com/-rb2PXLGZy0s/W2nQe3mXOSI/AAAAAAAARhQ/P8gV-bMtYbY2xxpTJNcYVxu3XDTUaugxQCLcBGAs/w72-h72-p-k-no-nu/beach-bora-bora-clouds-753626.jpg
        https://1.bp.blogspot.com/-FGnZn0040os/W3g7wnT2o-I/AAAAAAAARjE/xfgcR4fyvQgBgV5vFnyLtYOVK4d4dTouwCLcBGAs/w72-h72-p-k-no-nu/axl_2018_movie_4k_8k-7680x4320.jpg
        https://1.bp.blogspot.com/-h9kL603XSgY/XCe5rYiOczI/AAAAAAAARmY/qz_kMyR1q-scfs-rEGRzaof_QocYK7RegCLcBGAs/w72-h72-p-k-no-nu/spider_man_into_the_spider_verse_hd_4k.jpg
        https://2.bp.blogspot.com/-rb2PXLGZy0s/W2nQe3mXOSI/AAAAAAAARhQ/P8gV-bMtYbY2xxpTJNcYVxu3XDTUaugxQCLcBGAs/s640/beach-bora-bora-clouds-753626.jpg
        http://4.bp.blogspot.com/-poH-QXn7YGg/U-3ZTDkeF_I/AAAAAAAAISE/ms2gNIb-v-g/w72-h72-p-k-no-nu/Top-24-Inspired-181.jpg
        http://1.bp.blogspot.com/-iSU4orVuR9Y/VFYrwQZ5qYI/AAAAAAAAMnc/WY4VfCaeplw/w72-h72-p-k-no-nu/Wolf%2Bphotography2.jpg
        http://1.bp.blogspot.com/-vPQSh6RKijU/VEi7r3D-jJI/AAAAAAAAL2Q/bGHmyuoDp5M/w72-h72-p-k-no-nu/Building%2BIn%2BLondon1-4__880.jpeg
        http://1.bp.blogspot.com/-W4xKJSsVf3M/Uz73jPlctbI/AAAAAAAAGz4/K8Tw6PILMeY/w72-h72-p-k-no-nu/Beautiful+Japanese+places4.jpg
        https://1.bp.blogspot.com/-__qsdLxNtcQ/XhaOQle-ECI/AAAAAAAABQ4/S_7SGG_K8eQ7VXIU2wyPvTj9OyBfr_1sQCLcBGAsYHQ/w1200-h630-p-k-no-nu/iceland_poppies_orange_flowers_field-wallpaper-3840x2160.jpg
        https://lh3.googleusercontent.com/-tV86KJvppss/XE2Nb2Z2aAI/AAAAAAAAGu4/94E_AuB4YWAaJ59n43wmmd9rFa--OUuSQCJoC/w530-h338-n/IMG_6845%252C.png
        https://lh3.googleusercontent.com/-cr-2ZSQGMPg/XFWLfetwr7I/AAAAAAAAQQQ/TbwDk56BBIwb4IDDO0SwfArFSZyDG0i0wCJoC/w530-h360-n/DSC07294.JPG
        https://lh3.googleusercontent.com/-7ey25Wg_cQ4/X-Xy8LJPjMI/AAAAAAAAALE/raXQq0VZyBEzEDfAg3TcsOU_xc9z4szcwCLcBGAsYHQ/w1200-h630-p-k-no-nu/1608905381407960-0.png
      }.each_with_index do |link, i|
        it "largeimages ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        //lh3.googleusercontent.com/proxy/S-Z1P92Dd_u0DjYrz5Tb7j0mbZsGjPVffx9lHPQZCqqCFr6vAigCPOG0fEYKU6d-wIvwYr2WriAfh97KjBr9Bq1RKgyHzHq2fpAotTnJYOLd3x_tF2chsGBVuAewE7qp2QDtCYyomyn3dGjZ6cKUnYIC8w=s110-p-k
      }.each_with_index do |link, i|
        it "posted_website_preview_##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        0 https://lh3.googleusercontent.com/-okfI8E6JAgg/AAAAAAAAAAI/AAAAAAAAZa0/FEv9H8woCBg/s30-p-rw-no/photo.jpg
        7 https://lh3.googleusercontent.com/-okfI8E6JAgg/AAAAAAAAAAI/AAAAAAAAZa0/FEv9H8woCBg/s75-p-rw-no/photo.jpg
        _ https://lh3.googleusercontent.com/-bhgxgLsFYWI/AAAAAAAAAAI/AAAAAAAA4MI/_KuKE-Goa7E/s35-p-k-rw-no/photo.jpg
        - https://lh3.googleusercontent.com/-tl9-AdHhGiY/AAAAAAAAAAI/AAAAAAAA8uY/vVeZX8SbTXI/s35-p-k-rw-no/photo.jpg
        4 https://lh3.googleusercontent.com/-Rb833O10RB4/AAAAAAAAAAI/AAAAAAAAEJc/DawCLQGnaSA/s45-p-k-rw-no/photo.jpg
      }.each_slice 2 do |i, link|
        it "Google Plus userpic #{i}" do
          assert DirectLink.google link
        end
      end
      %w{
              - https://lh3.googleusercontent.com/-10bBuroWuoU/AAAAAAAAAAI/AAAAAAAAl90/ed314-fNMGg/s20-c-k-no/photo.jpg
           just https://lh5.googleusercontent.com/-RT6j6oYpZzU/AAAAAAAAAAI/AAAAAAAAAO4/WISrqFs1vT8/s46-c-k-no/photo.jpg
          no-no https://lh5.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/s64-c-k/photo.jpg
        no-k-no https://lh3.googleusercontent.com/-okfI8E6JAgg/AAAAAAAAAAI/AAAAAAAAAAA/AIcfdXD1lA9yGoSbsihWmGfnl6Z3Rn43WA/s64-c-mo/photo.jpg
              _ https://lh6.googleusercontent.com/-BQEbGrPRFk4/AAAAAAAAAAI/AAAAAAAAAAA/AIcfdXDBweE5VzGGy4zMraO_pqiLuFN3yQ/s46-c-k-no-mo/photo.jpg
      }.each_slice 2 do |i, link|
        it "Hangout userpic #{i}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh4.googleusercontent.com/KwxMEMlyjNKXqSqszuiCgPMi7_oE5fVv1Sw373HXBYlguP8AnIPAqefTS6DbBuurVGYRSxGrtDyKei1hae9Djf6rjiwjJd0aauA5Bg-z=s615
        https://lh5.googleusercontent.com/fRmAL_04p7oomNHCiV4tH4-agHSDBtLaWi_Tb6bgE5ZSHVu5OjQF3iRn06nNwP3ywZwdFP92zWM-o8yw0cn6m0tDTBARuO6F9e0wYu_1=s685
        https://lh5.googleusercontent.com/FcYUQBKLXWtFLEvbQduvu7FHUm2f7U_MVdMBVnNbpwfzKHIU-xABkudxw-m21SlM0jFYRHedh7Is5Dg6qlgIQF1iSndlWjiKCTTsUo1w=s1080
        https://lh5.googleusercontent.com/gcDb3dxbch9jUKPzKGawJiwtHcNS9wp6o2sc0aJj9wOWQA-u8kXmKIrZ-TkLxajee6qLaT2p6OK2N7klTJ9CxU66OnpBhYJMg0q9QEdq5Q=s2160
      }.each_with_index do |link, i|
        it "google keep ##{i + 1}" do
          assert DirectLink.google link
        end
      end

      end

      # TODO: expand this for every branch in lib
      %w{
        https_long_blogspot https://1.bp.blogspot.com/-__qsdLxNtcQ/XhaOQle-ECI/AAAAAAAABQ4/S_7SGG_K8eQ7VXIU2wyPvTj9OyBfr_1sQCLcBGAsYHQ/w1200-h630-p-k-no-nu/iceland_poppies_orange_flowers_field-wallpaper-3840x2160.jpg https://1.bp.blogspot.com/-__qsdLxNtcQ/XhaOQle-ECI/AAAAAAAABQ4/S_7SGG_K8eQ7VXIU2wyPvTj9OyBfr_1sQCLcBGAsYHQ/s0/
        http_short_blogspot http://4.bp.blogspot.com/-poH-QXn7YGg/U-3ZTDkeF_I/AAAAAAAAISE/ms2gNIb-v-g/w72-h72-p-k-no-nu/Top-24-Inspired-181.jpg https://4.bp.blogspot.com/-poH-QXn7YGg/U-3ZTDkeF_I/AAAAAAAAISE/ms2gNIb-v-g/s0/
        just_gplus https://lh3.googleusercontent.com/-NiGph3ObOPg/XE3DgnavXlI/AAAAAAABvgE/pcPPCe88rsU1r941wwP76TVf_o89i74kwCJoC/w530-h353-n/DSCF0753.JPG https://lh3.googleusercontent.com/-NiGph3ObOPg/XE3DgnavXlI/AAAAAAABvgE/pcPPCe88rsU1r941wwP76TVf_o89i74kwCJoC/s0/
        google_keep https://lh5.googleusercontent.com/fRmAL_04p7oomNHCiV4tH4-agHSDBtLaWi_Tb6bgE5ZSHVu5OjQF3iRn06nNwP3ywZwdFP92zWM-o8yw0cn6m0tDTBARuO6F9e0wYu_1=s685 https://lh5.googleusercontent.com/fRmAL_04p7oomNHCiV4tH4-agHSDBtLaWi_Tb6bgE5ZSHVu5OjQF3iRn06nNwP3ywZwdFP92zWM-o8yw0cn6m0tDTBARuO6F9e0wYu_1=s0
      }.each_slice 3 do |name, link, o|
        it "replaces s0 and schema correctly #{name}" do
          assert_equal o, DirectLink.google(link)
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

      it "ErrorNotFound when album is empty" do
        e = assert_raises DirectLink::ErrorNotFound do
          DirectLink.imgur "https://imgur.com/a/wPi63mj"
        end
        assert_nil e.cause if Exception.instance_methods.include? :cause  # Ruby 2.1
      end

      valid_imgur_image_url_direct = "https://i.imgur.com/dCQprEq.jpg"
      it 200 do
        assert_equal [[valid_imgur_image_url_direct, 5760, 3840, "image/jpeg"]],
                     DirectLink.imgur(valid_imgur_image_url_direct)
      end
      valid_imgur_image_url_album = "https://imgur.com/a/wPi63mj"
      [400, 500, 503].each do |error_code|
        [
          [valid_imgur_image_url_direct, :direct],
          [valid_imgur_image_url_album, :album],
        ].each do |url, kind|
          it "retries limited amout of times on error #{error_code} (#{kind})" do
            tries = 0
            e = assert_raises DirectLink::ErrorAssert do
              NetHTTPUtils.stub :request_data, ->*{ tries += 1; raise NetHTTPUtils::Error.new "", error_code } do
                DirectLink.imgur url, 4   # do not remove `4` or test will hang
              end
            end
            assert_equal error_code, e.cause.code if Exception.instance_methods.include? :cause  # Ruby 2.1
            assert_equal 3, tries
          end
        end
      end
      it "does not throw 400 after a successfull retry" do
        f = 0
        m = NetHTTPUtils.method :request_data
        NetHTTPUtils.stub :request_data, lambda{ |*args|
          raise NetHTTPUtils::Error.new "", 400 if 1 == f += 1
          m.call *args
        } do
          assert_equal [[valid_imgur_image_url_direct, 5760, 3840, "image/jpeg"]],
            DirectLink.imgur(valid_imgur_image_url_direct, 4)   # do not remove `4` or test may hang
        end
      end
      it 404 do
        e = assert_raises DirectLink::ErrorNotFound do
          NetHTTPUtils.stub :request_data, ->*{ raise NetHTTPUtils::Error.new "", 404 } do
            DirectLink.imgur valid_imgur_image_url_direct
          end
        end
        assert_equal 404, e.cause.code if Exception.instance_methods.include? :cause  # Ruby 2.1
      end

      [ # TODO: move these end line comments to test names; and do the same in other tests
        ["https://imgur.com/a/j5xmY", "https://i.imgur.com/KTTuoyN.jpg", 2828, 2828, "image/jpeg"],   # single photo album
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
        ["http://imgur.com/gallery/nKAwE/new", 28, "https://i.imgur.com/VQhR8hB.jpg", "https://i.imgur.com/axlzNRL.jpg"],
        ["http://m.imgur.com/rarOohr", "https://i.imgur.com/rarOohr.jpg"],
        ["http://imgur.com/r/wallpaper/j39dKMi", "https://i.imgur.com/j39dKMi.jpg?1"],
        ["http://imgur.com/gallery/jm0OKQM", DirectLink::ErrorNotFound],  # this id does not belong to gallery but to an image, that is probably irrelevant
        ["http://imgur.com/gallery/oZXfZ", DirectLink::ErrorNotFound],    # this id does not belong to gallery but to an album, that is probably irrelevant
        ["http://imgur.com/gallery/dCQprEq/new", "https://i.imgur.com/dCQprEq.jpg", 5760, 3840, "image/jpeg"],
        ["https://imgur.com/S5u2xRB?third_party=1#_=_", "https://i.imgur.com/S5u2xRB.jpg", 2448, 2448, "image/jpeg"],
        ["https://imgur.com/3eThW", "https://i.imgur.com/3eThW.jpg", 2560, 1600, "image/jpeg"],
        ["https://i.imgur.com/RGO6i.mp4", "https://i.imgur.com/RGO6i.gif", 339, 397, "image/gif"],
        ["https://imgur.com/a/oacI3gl", 2, "https://i.imgur.com/9j4KdkJ.png", "https://i.imgur.com/QpOBvRY.png"],
        ["https://i.imgur.com/QpOBvRY.png", "https://i.imgur.com/QpOBvRY.png", 460, 460, "image/png"],
        # some other tests not sure we need them
        ["http://i.imgur.com/7xcxxkR.gifv", "http://i.imgur.com/7xcxxkRh.gif"],
        ["http://imgur.com/HQHBBBD", "https://i.imgur.com/HQHBBBD.jpg", 1024, 768, "image/jpeg"],
        ["http://imgur.com/a/AdJUK", 3, "https://i.imgur.com/Yunpxnx.jpg", "https://i.imgur.com/2epn2nT.jpg", "https://i.imgur.com/3afw2aF.jpg"],
        ["https://imgur.com/9yaMdJq", "https://i.imgur.com/9yaMdJq.mp4", 720, 404, "video/mp4"],
        ["http://imgur.com/gallery/dCQprEq/new", "https://i.imgur.com/dCQprEq.jpg", 5760, 3840, "image/jpeg"],
        ["https://i.imgur.com/fFUTSJu.jpg?fb", "https://i.imgur.com/fFUTSJu.jpg", 1469, 2200, "image/jpeg"],    # from reddit.com/93mtba
        ["https://i.imgur.com/IxUrhGX.jpeg", "https://i.imgur.com/IxUrhGX.jpg", 4384, 3012, "image/jpeg"],  # jpEg
        ["https://imgur.com/gallery/9f2s9EE", "https://i.imgur.com/9f2s9EE.mp4", 960, 1438, "video/mp4"],  # mp4
      ].each_with_index do |t, i|
        url, n, first, last, type = t
        it "kinds of post ##{i + 1}" do
          case last
          when NilClass
            if n.is_a? Class
              assert_raises n do
                DirectLink.imgur url
              end
            else
              real = DirectLink.imgur url
              assert_equal 1, real.size
              assert_equal n, real.first.first
            end
          when Numeric
            real = DirectLink.imgur url
            assert_equal 1, real.size
            assert_equal [n, first, last, type], real.first
          when String
            real = DirectLink.imgur url
            assert_equal n, real.size
            assert_equal first, real.first.first
            assert_equal last, real.last.first
          else
            fail "bug in tests"
          end
        end
      end
    end

    # TODO we need tests that check we really get dimensions from `DirectLink()` method called on wiki and reddit links
    #      and maaaaybe move some tests from here to the context about giveup
    [
      [ :_500px, [
        ["https://500px.com/photo/264092015/morning-rider-by-tiger-seo", [1200, 800, "https://drscdn.500px.org/photo/264092015/m%3D900/v2?sig=68a9206477f573d8e2838faa6a929e7267f22dc5f9e98f1771f7a8a63efa2ed7", "jpeg"]],
        ["https://500px.com/photo/1017579834/-poppies-flowers-by-David-Dubnitskiy/", [1819, 2500, "https://drscdn.500px.org/photo/1017579834/m%3D900/v2?sig=022e3e9dd836ffd8c1d31ae26c83735e4e42b4c8733d0c4380d8270aebbca44e", "jpeg"]],
        ["https://500px.com/photo/1017557263/iss%E5%87%8C%E6%97%A5%E5%81%8F%E9%A3%9F-by-%E7%A7%8B%E8%A3%A4Choku-/", [2048, 2048, "https://drscdn.500px.org/photo/1017557263/m%3D2048/v2?sig=1994a09e33794117082e91fa58c40614a2bfd19d3e0dd78e067968d38aca92be", "jpeg"]]
      ] ],
      [ :flickr, [
        ["https://www.flickr.com/photos/tomas-/17220613278/", DirectLink::ErrorNotFound],
        ["https://www.flickr.com/photos/16936123@N07/18835195572", DirectLink::ErrorNotFound],
        ["https://www.flickr.com/photos/44133687@N00/17380073505/", [3000, 2000, "https://live.staticflickr.com/7757/17380073505_ed5178cc6a_o.jpg"]],                            # trailing slash
        ["https://www.flickr.com/photos/jacob_schmidt/18414267018/in/album-72157654235845651/", DirectLink::ErrorNotFound],                                                      # username in-album
        ["https://www.flickr.com/photos/tommygi/5291099420/in/dateposted-public/", [1600, 1062, "https://live.staticflickr.com/5249/5291099420_29fae96e38_h.jpg"]],              # username in-public
        ["https://www.flickr.com/photos/132249412@N02/18593786659/in/album-72157654521569061/", DirectLink::ErrorNotFound],
        ["https://www.flickr.com/photos/130019700@N03/18848891351/in/dateposted-public/", [4621, 3081, "https://live.staticflickr.com/3796/18848891351_f751b35aeb_o.jpg"]],      # userid   in-public
        ["https://www.flickr.com/photos/frank3/3778768209/in/photolist-6KVb92-eCDTCr-ur8K-7qbL5z-c71afh-c6YvXW-7mHG2L-c71ak9-c71aTq-c71azf-c71aq5-ur8Q-6F6YkR-eCDZsD-eCEakg-eCE6DK-4ymYku-7ubEt-51rUuc-buujQE-ur8x-9fuNu7-6uVeiK-qrmcC6-ur8D-eCEbei-eCDY9P-eCEhCk-eCE5a2-eCH457-eCHrcq-eCEdZ4-eCH6Sd-c71b5o-c71auE-eCHa8m-eCDSbz-eCH1dC-eCEg3v-7JZ4rh-9KwxYL-6KV9yR-9tUSbU-p4UKp7-eCHfwS-6KVbAH-5FrdbP-eeQ39v-eeQ1UR-4jHAGN", [4096, 2723, "https://live.staticflickr.com/2499/3778768209_dfa75a41cc_4k.jpg"]],
        ["https://www.flickr.com/photos/patricksloan/18230541413/sizes/l", [2048, 491, "https://live.staticflickr.com/5572/18230541413_fec4783d79_k.jpg"]],
        ["https://flic.kr/p/vPvCWJ", [5120, 3413, "https://live.staticflickr.com/507/19572004110_1bd49c5ebd_5k.jpg"]],
      ] ],
      [ :wiki, [
        ["https://en.wikipedia.org/wiki/Prostitution_by_country#/media/File:Prostitution_laws_of_the_world.PNG", "https://upload.wikimedia.org/wikipedia/commons/e/e8/Prostitution_laws_of_the_world.PNG"],
        ["https://en.wikipedia.org/wiki/Third_Party_System#/media/File:United_States_presidential_election_results,_1876-1892.svg", DirectLink::ErrorAssert],
        ["http://commons.wikimedia.org/wiki/File:Eduard_Bohlen_anagoria.jpg", "https://upload.wikimedia.org/wikipedia/commons/0/0d/Eduard_Bohlen_anagoria.jpg"],
        ["https://en.wikipedia.org/wiki/Spanish_Civil_War#/media/File:Alfonso_XIIIdeEspa%C3%B1a.jpg", "https://upload.wikimedia.org/wikipedia/commons/f/fb/Alfonso_XIIIdeEspa%C3%B1a.jpg"],   # escaped input URI
        ["https://en.wikipedia.org/wiki/File:Tyson_Lewis.jpg", "https://upload.wikimedia.org/wikipedia/en/c/cd/Tyson_Lewis.jpg"],  # exists only in en.wiki, not in commons
      ] ],
      [ :reddit, [
        ["https://www.reddit.com/r/cacography/comments/32tq0i/c/", [true, "http://i.imgur.com/vy6Ms4Z.jpg"]],
        ["http://redd.it/32tq0i", [true, "http://i.imgur.com/vy6Ms4Z.jpg"]],                    # TODO maybe check that it calls #imgur recursively
        ["https://i.redd.it/c8rk0kjywhy01.jpg", [true, "https://i.redd.it/c8rk0kjywhy01.jpg"]],
        ["https://i.redd.it/si758zk7r5xz.jpg", [true, "https://i.redd.it/si758zk7r5xz.jpg"]],   # it is 404 but `.reddit` does not care -- it just returns the url
        ["https://reddit.com/123456", [true, "https://i.ytimg.com/vi/b9upM4RbIeU/hqdefault.jpg"]],
        # ["https://www.reddit.com/r/travel/988889", [true, "https://i.redd.it/3h5xls6ehrg11.jpg"]],
        ["http://redd.it/988889", [true, "https://i.redd.it/3h5xls6ehrg11.jpg"]],
        ["https://www.reddit.com/r/CatsStandingUp/duplicates/abn0ua/cat/", [true, "https://v.redd.it/s9b86afb6w721/DASH_2_4_M?source=fallback"]],
        ["https://www.reddit.com/r/hangers/comments/97you5/tara_radovic/", [true, "https://i.imgur.com/rbLqgOu.jpg"]],   # "crossport" from Imgur
        ["https://www.reddit.com/gallery/i1u6rb", [true, [["image/jpg", 1440, 1440, "https://preview.redd.it/x31msdj6vee51.jpg?width=1440&format=pjpg&auto=webp&s=b79952f8364bb98692d978944347f19e28774d1b"], ["image/jpg", 2441, 2441, "https://preview.redd.it/mwkzq6j6vee51.jpg?width=2441&format=pjpg&auto=webp&s=455e669356550351e6b8768d8009de616c11142a"], ["image/jpg", 1440, 1440, "https://preview.redd.it/0ws1j8j6vee51.jpg?width=1440&format=pjpg&auto=webp&s=061582da8478e7601a7ce7a97fa1663852873726"], ["image/jpg", 1440, 1440, "https://preview.redd.it/2un68aj6vee51.jpg?width=1440&format=pjpg&auto=webp&s=a980f0e5814c2360f5d7a0fb12f391e304942c06"], ["image/jpg", 3024, 3780, "https://preview.redd.it/5bsfaej6vee51.jpg?width=3024&format=pjpg&auto=webp&s=9b96b4b7262eebacc7571a9f0ad902e2034bf990"], ["image/jpg", 1440, 1440, "https://preview.redd.it/0z010ej6vee51.jpg?width=1440&format=pjpg&auto=webp&s=f0c29be6ec98b835a482c7584cca43fd16217bc8"], ["image/jpg", 1440, 1440, "https://preview.redd.it/aylm2ej6vee51.jpg?width=1440&format=pjpg&auto=webp&s=39cf471b14020a1f137bc9bbb294bf5489cab3e7"]]]],   # TODO: find smaller gallery
        ["https://www.reddit.com/i1u6rb",         [true, [["image/jpg", 1440, 1440, "https://preview.redd.it/x31msdj6vee51.jpg?width=1440&format=pjpg&auto=webp&s=b79952f8364bb98692d978944347f19e28774d1b"], ["image/jpg", 2441, 2441, "https://preview.redd.it/mwkzq6j6vee51.jpg?width=2441&format=pjpg&auto=webp&s=455e669356550351e6b8768d8009de616c11142a"], ["image/jpg", 1440, 1440, "https://preview.redd.it/0ws1j8j6vee51.jpg?width=1440&format=pjpg&auto=webp&s=061582da8478e7601a7ce7a97fa1663852873726"], ["image/jpg", 1440, 1440, "https://preview.redd.it/2un68aj6vee51.jpg?width=1440&format=pjpg&auto=webp&s=a980f0e5814c2360f5d7a0fb12f391e304942c06"], ["image/jpg", 3024, 3780, "https://preview.redd.it/5bsfaej6vee51.jpg?width=3024&format=pjpg&auto=webp&s=9b96b4b7262eebacc7571a9f0ad902e2034bf990"], ["image/jpg", 1440, 1440, "https://preview.redd.it/0z010ej6vee51.jpg?width=1440&format=pjpg&auto=webp&s=f0c29be6ec98b835a482c7584cca43fd16217bc8"], ["image/jpg", 1440, 1440, "https://preview.redd.it/aylm2ej6vee51.jpg?width=1440&format=pjpg&auto=webp&s=39cf471b14020a1f137bc9bbb294bf5489cab3e7"]]]],   # TODO: find smaller gallery
        ["https://www.reddit.com/gallery/i3y7pc", [true, "https://www.reddit.com/gallery/i3y7pc"]],   # deleted gallery
        ["https://www.reddit.com/ik6c6a", [true, "https://www.reddit.com/r/Firewatch/comments/ik6brf/new_wallpaper_for_my_triple_monitor_setup/"]],   # deleted gallery
        ["https://www.reddit.com/kbjdwc", [true, [["image/jpg", 500, 500, "https://preview.redd.it/71t8ljeexo461.jpg?width=500&format=pjpg&auto=webp&s=df211fe0699e3970681ffe493ed1af79725857e8"], ["image/jpg", 720, 446, "https://preview.redd.it/c11nt7hexo461.jpg?width=720&format=pjpg&auto=webp&s=5e34ab0e6d54c0acfdb47f1daaf283087c5ad6a6"], ["image/jpg", 713, 588, "https://preview.redd.it/67mqvllexo461.jpg?width=713&format=pjpg&auto=webp&s=969dfb52bedd6f0055249aa8b7454b23adaa946e"]]]],   # failed media
        # TODO: empty result? https://redd.it/9hhtsq
      ] ],
    ].each do |method, tests|
      next if method == :vk && ENV.include?("CI")
      describe "kinds of links #{method}" do
        tests.each_with_index do |(input, expectation), i|
          it "##{i + 1}" do
            if expectation.is_a? Class
              assert_raises expectation, input do
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

    describe "kinds of links vk" do
      next if ENV.include? "CI"
      [
        ["https://vk.com/wall-105984091_7806", [960, 1280, "https://userapi.com/impf/c855224/v855224900/a72f1/7OZ8ux9Wcwo.jpg"]],
        # ["https://vk.com/wall298742340_4715", [1080, 1080, "https://userapi.com/impf/c857136/v857136625/15e38b/CsCqsJD174A.jpg"]],  # TODO: it's now 404
        ["https://vk.com/wall-185182611_454?z=photo-185182611_457239340%2Fwall-185182611_454", [1280, 960, "https://userapi.com/impf/c851028/v851028578/1a62f6/VB4SdR1O6Tg.jpg"]],
        ["https://vk.com/wall-105984091_7946?z=photo-105984091_457243312%2Falbum-105984091_00%2Frev", [1280, 875, "https://userapi.com/impf/c852020/v852020134/1b6b36/0IsDFb-Hda4.jpg"]],
        ["https://vk.com/id57030827?z=photo57030827_456241143%2Falbum57030827_0", [1920, 1440, "https://userapi.com/impf/c845322/v845322944/167836/bP9z41BybhI.jpg"]],
        ["https://vk.com/id57030827?z=photo57030827_456241143", [1920, 1440, "https://userapi.com/impf/c845322/v845322944/167836/bP9z41BybhI.jpg"]],
        ["https://vk.com/photo1_215187843?all=1", [2560, 1913, "https://userapi.com/impf/c210/v210001/6/53_VwoACy4I.jpg"]],
        ["https://vk.com/photo298742340_456243948?rev=1", [1583, 1080, "https://userapi.com/impf/c852224/v852224479/321be/9rZaJ2QTdz4.jpg"]],
        ["https://vk.com/photo-155488973_456242404", [1486, 1000, "https://userapi.com/impf/c852132/v852132877/8578e/m6AJWiskiKE.jpg"]],
        # ["https://vk.com/id2272074?z=photo2272074_264578776%2Fphotos2272074", [604, 484, "https://userapi.com/impf/c10472/u2272074/-7/x_407b2ba2.jpg"]],  # TODO: it's now 404
        ["https://vk.com/feed?section=likes&z=photo-117564754_456261460%2Fliked3902406", [1024, 1335, "https://userapi.com/impf/c854028/v854028353/895b6/izQJresLdf0.jpg"]],
        ["https://vk.com/likizimy?z=photo-42543351_456239941%2Fwall-42543351_1908", [1179, 1731, "https://userapi.com/impf/c855036/v855036571/60f7b/ryCPJIMyMkI.jpg"]],
        ["https://vk.com/e_rod?z=photo298742340_457247118%2Fphotos298742340", [1728, 2160, "https://userapi.com/impf/c858320/v858320596/c7714/oImGe4o1ZJI.jpg"]],
      ].each_with_index do |(input, expectation), i|
        it "##{i + 1}" do
          result = DirectLink.method(:vk).call input
          assert_equal 1, result.size
          result[0][-1].tap do |url|
            url.replace( URI.parse(url).tap do |_|
              _.host = _.host.split(?.).drop(1).join(?.)
              _.query = nil
            end.to_s )
          end
          assert_equal [expectation], result, "#{input} :: #{result.inspect} != #{expectation.inspect}"
        end
      end
    end

    {
      google: [
        "https://lh3.googleusercontent.com/-NVJgqmI_2Is/WqMM2OMYg-I/AAAAAAAALrk/5-p3JL3iZt0Ho9dOf_p3gpddzqwr3Wp0ACJoC/w424-h318-n/001",
        "//lh3.googleusercontent.com/proxy/DZtTi5KL7PqiBwJc8weNGLk_Wi2UTaQH0AC_h2kuURiu0AbwyI2ywOk2XgdAjL7ceg=w530-h354-n",
        "//1.bp.blogspot.com/-rYk_u-qROQc/WngolJ8M0LI/AAAAAAAAD-w/woivnaIVzasBPG5C2T1t-VrWKRd_U6lMgCLcBGAs/w530-h278-p/i-469.jpg",
        "https://2.bp.blogspot.com/-rb2PXLGZy0s/W2nQe3mXOSI/AAAAAAAARhQ/P8gV-bMtYbY2xxpTJNcYVxu3XDTUaugxQCLcBGAs/s640/beach-bora-bora-clouds-753626.jpg",
        "http://4.bp.blogspot.com/-poH-QXn7YGg/U-3ZTDkeF_I/AAAAAAAAISE/ms2gNIb-v-g/w72-h72-p-k-no-nu/Top-24-Inspired-181.jpg",
        "https://lh5.googleusercontent.com/FcYUQBKLXWtFLEvbQduvu7FHUm2f7U_MVdMBVnNbpwfzKHIU-xABkudxw-m21SlM0jFYRHedh7Is5Dg6qlgIQF1iSndlWjiKCTTsUo1w=s1080",
      ],
      imgur: [
        ["https://imgur.com/3eThW", "https://imgur.com/3eThW"],
        ["https://i.imgur.com/3eThW", "https://imgur.com/3eThW"],
        ["https://m.imgur.com/3eThW", "https://imgur.com/3eThW"],
        ["https://www.imgur.com/3eThW", "https://imgur.com/3eThW"],
        ["https://goo.gl/ySqUb5", "https://i.imgur.com/QpOBvRY.png"],
      ],
      _500px: [
        %w{ https://500px.com/photo/112134597/milky-way-by-tom-hall https://500px.com/photo/112134597/milky-way-by-tom-hall },
      ],
      flickr: [
        "https://www.flickr.com/photos/59880970@N07/15773941043/in/dateposted-public/",
        ["https://flic.kr/p/vPvCWJ", "https://www.flickr.com/photos/mlopezphotography/19572004110/"],
      ],
      wiki: [
        "https://en.wikipedia.org/wiki/Third_Party_System#/media/File:United_States_presidential_election_results,_1876-1892.svg",
        ["http://commons.wikimedia.org/wiki/File:Eduard_Bohlen_anagoria.jpg", "https://commons.wikimedia.org/wiki/File:Eduard_Bohlen_anagoria.jpg"],
      ],
      reddit: [
        "https://www.reddit.com/r/cacography/comments/32tq0i/c/",
        ["http://redd.it/32tq0i", "https://www.reddit.com/comments/32tq0i"],
        ["https://reddit.com/123456", "https://www.reddit.com/r/funny/comments/123456/im_thinking_about_getting_a_dog_and_youtubed_ways/"],
        # ["https://www.reddit.com/r/travel/988889", "https://www.reddit.com/r/travel/comments/988889/playa_miramar_in_guaymas_sonora/"],
        "https://www.reddit.com/r/PareidoliaGoneWild/comments/hzrlq6/beard_trimmer_on_display_at_best_buy_they_knew/", # NSFW causes redirect to /over_18? if the special cookie not provided
      ],
      vk: [
        "https://vk.com/id57030827?z=photo57030827_456241143",
      ],
    }.each do |method, tests|
      describe "DirectLink() sees domain name and calls #{method}" do
        tests.each_with_index do |(input, expected), i|
          it "##{i + 1}" do
            DirectLink.stub method, ->(link, timeout = nil){
              assert_equal (expected || input), link
              throw :_
            } do
              catch :_ do
                DirectLink input
                fail "DirectLink.#{method} was not called"
              end
            end
          end
        end
      end
    end

    # TODO: make a Reddit describe
    it "retries limited amout of times on error JSON::ParserError" do
      link = "https://www.reddit.com/r/gifs/comments/9ftc8f/low_pass_wake_vortices/?st=JM2JIKII&amp;sh=c00fea4f"
      tries = 0
      m = NetHTTPUtils.method :request_data
      e = assert_raises DirectLink::ErrorBadLink do
        NetHTTPUtils.stub :request_data, lambda{ |*args|
          if args.first == "https://www.reddit.com/9ftc8f.json"
            tries += 1
            raise JSON::ParserError
          end
          # this gem call should never return success -- it should experience JSON::ParserError
          #   so I'm not much sure why do we need this line
          m.call *args
        } do
          # why?
          t = ENV.delete "REDDIT_SECRETS"
          begin
            DirectLink.reddit link, 3   # do not remove `4` or test will hang
          ensure
            ENV["REDDIT_SECRETS"] = t
          end
        end
      end
      assert_instance_of JSON::ParserError, e.cause if Exception.instance_methods.include? :cause  # Ruby 2.1
      assert_equal 3, tries
    end
    it "Reddit correctly parses out id when no token provided" do
      # this URL isn't supposed to not throw exception -- FastImage does not handle this media type (see the next test)
      t = ENV.delete "REDDIT_SECRETS"
      FastImage.stub :new, lambda{ |link, *|
        assert_equal "https://v.redd.it/2tyovczka8m11/DASH_4_8_M?source=fallback", link
        throw :_
      } do
        begin
          catch :_ do
            DirectLink "https://www.reddit.com/r/gifs/comments/9ftc8f/low_pass_wake_vortices/?st=JM2JIKII&amp;sh=c00fea4f"
          end
        ensure
          ENV["REDDIT_SECRETS"] = t
        end
      end
    end
    it "it is really impossible to get dimensions from the shitty Reddit media hosting" do
      # TODO: why does it call the same Net::HTTP::Get twice?
      assert_raises FastImage::UnknownImageType do
        DirectLink "https://v.redd.it/2tyovczka8m11/DASH_4_8_M"
      end
    end

    describe "throws ErrorBadLink if method does not match the link" do
      %i{ google imgur flickr _500px wiki reddit vk }.each do |method|
        ["", "test", "http://example.com/"].each_with_index do |url, i|
          it "#{method} ##{i + 1}" do
            assert_raises DirectLink::ErrorBadLink do
              DirectLink.method(method).call url
            end
          end
        end
      end
    end

    # TODO: test each webservice-specific method
    # TODO: check not in OpenSSL but higher -- in Net::HTTP
        it "does not cause the SystemStackError" do
          OpenSSL::Buffering.module_eval do
            old = instance_method :write
            depths = []
            define_method :write do |arg|
              depths.push caller.size
              raise "probable infinite recursion" if [1]*10 == depths.each_cons(2).map{ |i,j| j-i } if depths.size > 10
              old.bind(self).(arg)
            end
          end
          DirectLink "https://i.redd.it/gdo0cnmeagx01.jpg"
        end

  end

  describe "DirectLink()" do

    it "does not raise JSON::ParserError -- Reddit sucks and may respond with wrong content type" do
      DirectLink.reddit "https://www.reddit.com/123456"   # just to initialize DirectLink.reddit_bot
                                                          # I don't remember for what though
                                                          # oh, maybe to avoid rasing in initializer
                                                          # but why not?
      limit = 0
      loop do
        limit += 1
        tries = 0
        m = JSON.method :load
        JSON.stub :load, ->*args{
          if limit == tries += 1
            raise JSON::ParserError
          else
            m.call *args
          end
        } do
          t = ENV.delete "REDDIT_SECRETS"
          begin
            DirectLink.reddit "https://www.reddit.com/123456"
          ensure
            ENV["REDDIT_SECRETS"] = t
          end
        end
        break if 1 == tries
      end
      assert_equal 2, limit, "`JSON.load` was called only once?!"
    end

    # thanks to gem addressable
    it "does not throw URI::InvalidURIError if there are brackets" do
      assert_equal 404, (
        assert_raises NetHTTPUtils::Error do
          DirectLink "https://www.flickr.com/photos/leogaggl/28488925847/%20[2048x1152]"
        end.code
      )
    end

    it "throws ErrorNotFound when Reddit gallery is removed" do
      assert_raises DirectLink::ErrorNotFound do
        DirectLink "https://www.reddit.com/gallery/i3y7pc"
      end
    end

    it "follows Reddit crosspost" do
      assert_equal %w{ image/png image/png }, DirectLink("https://www.reddit.com/ik6c6a").map(&:type)
    end

    it "throws ErrorBadLink if link is invalid" do
      assert_equal "test".inspect, (
        assert_raises DirectLink::ErrorBadLink do
          DirectLink "test"
        end
      ).message
    end

    describe "does not shadow the internal exception" do
      [
        SocketError,
        Errno::ECONNRESET,
      ].each do |exception|
        it "raises #{exception} from the redirect resolving stage" do
          assert_raises exception do
            NetHTTPUtils.stub :request_data, ->*{ raise exception.new } do
              DirectLink "http://example.com/404"
            end
          end
        end
      end
      it "raises Net::OpenTimeout -- server side issues can happen (not related to User Agent)" do
        assert_raises Net::OpenTimeout do
          NetHTTPUtils.stub :request_data, ->*{ raise Net::OpenTimeout.new } do
            DirectLink "http://example.com/404"
          end
        end
      end
      [ # TODO this URLs may be reused from tests that check that this method calls internal method
        [:google, "//lh3.googleusercontent.com/proxy/DZtTi5KL7PqiBwJc8weNGLk_Wi2UTaQH0AC_h2kuURiu0AbwyI2ywOk2XgdAjL7ceg=w530-h354-n"],
        [:imgur, "http://imgur.com/HQHBBBD"],
        [:flickr, "https://www.flickr.com/photos/44133687@N00/17380073505/"],
        [:_500px, "https://500px.com/photo/112134597/milky-way-by-tom-hall"],
        [:wiki, "http://commons.wikimedia.org/wiki/File:Eduard_Bohlen_anagoria.jpg"],
        [:reddit, "https://www.reddit.com/123456"],
        [:vk, "https://vk.com/"],
      ].each do |method, link|
        it "can otherwise raise DirectLink::ErrorBadLink #{method}" do
          e = assert_raises(DirectLink::ErrorBadLink, link) do
            DirectLink.stub method, ->*{ raise DirectLink::ErrorBadLink.new "test" } do
              DirectLink link
            end
          end
          assert_equal "\"test\" -- if you think this link is valid, please report the issue", e.message
        end
      end
    end

    describe "other domains tests" do
      [
        # ["http://www.aeronautica.difesa.it/organizzazione/REPARTI/divolo/PublishingImages/6%C2%B0%20Stormo/2013-decollo%20al%20tramonto%20REX%201280.jpg", ["http://www.aeronautica.difesa.it/organizzazione/REPARTI/divolo/PublishingImages/6%C2%B0%20Stormo/2013-decollo%20al%20tramonto%20REX%201280.jpg", 1280, 853, :jpeg], nil, 1],   # website is dead?
        # ["http://minus.com/lkP3hgRJd9npi", SocketError, /nodename nor servname provided, or not known|No address associated with hostname/, 0],
        ["http://www.cutehalloweencostumeideas.org/wp-content/uploads/2017/10/Niagara-Falls_04.jpg", SocketError, /nodename nor servname provided, or not known|Name or service not known|getaddrinfo: Name does not resolve/, 0],
      ].each_with_index do |(input, expectation, message_string_or_regex, max_redirect_resolving_retry_delay), i|
        it "##{i + 1}" do
          if expectation.is_a? Class
            e = assert_raises expectation, "for #{input}" do
              DirectLink input, max_redirect_resolving_retry_delay
            end
            if message_string_or_regex.is_a? String
              assert_equal message_string_or_regex, e.message, "for #{input}"
            else
              assert_match message_string_or_regex, e.message, "for #{input}"
            end
          else
            u, w, h, t = expectation
            result = DirectLink input, max_redirect_resolving_retry_delay
            assert_equal DirectLink.class_variable_get(:@@directlink).new(u, w, h, t), result, "for #{input}"
          end
        end
      end
    end

    describe "giving up" do
      [
        ["http://example.com",                    FastImage::UnknownImageType],
        # ["https://www.tic.com/index.html",        FastImage::UnknownImageType, true],   # needs new test or stub
        # ["https://www.tic.com/index.html",        2],                                   # needs new test or stub
        ["http://imgur.com/HQHBBBD",              FastImage::UnknownImageType, true],
        ["http://imgur.com/HQHBBBD",              "https://i.imgur.com/HQHBBBD.jpg?fb"],  # .at_css("meta[@property='og:image']")
        ["https://www.deviantart.com/nadyasonika/art/Asuka-Langley-Beach-Time-590134861", FastImage::UnknownImageType, true],
        ["https://www.deviantart.com/nadyasonika/art/Asuka-Langley-Beach-Time-590134861", "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/943f66cb-78ad-40f2-a086-44420b98b431/d9rcmz1-5cbc5670-0193-485b-ac14-755ddb9562f4.jpg/v1/fill/w_1024,h_732,q_75,strp/asuka_langley_beach_time_by_nadyasonika_d9rcmz1-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOiIsImlzcyI6InVybjphcHA6Iiwib2JqIjpbW3siaGVpZ2h0IjoiPD03MzIiLCJwYXRoIjoiXC9mXC85NDNmNjZjYi03OGFkLTQwZjItYTA4Ni00NDQyMGI5OGI0MzFcL2Q5cmNtejEtNWNiYzU2NzAtMDE5My00ODViLWFjMTQtNzU1ZGRiOTU2MmY0LmpwZyIsIndpZHRoIjoiPD0xMDI0In1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.L6OhXuQZ_9ovKOdjjuQbvxpD0mG8M_KiqV4ljEDfW3Q"],
        ["https://calgary.skyrisecities.com/news/2019/11/blue-morning-light", "https://cdn.skyrisecities.com/sites/default/files/images/articles/2019/11/39834/39834-132071.jpg"], # og:image without scheme
        ["https://www.reddit.com/r/darksouls3/comments/e59djh/hand_it_over_that_thing_your_wallpaper/", DirectLink::ErrorBadLink, true],
        ["https://www.reddit.com/r/darksouls3/comments/e59djh/hand_it_over_that_thing_your_wallpaper/", 6],
      ].each_with_index do |(input, expectation, giveup), i|
        it "##{i + 1} (#{URI(input).host}) (giveup=#{!!giveup})" do  # to match with minitest `-n` run flag
          ti = ENV.delete "IMGUR_CLIENT_ID" if %w{ imgur com } == URI(input).host.split(?.).last(2)
          tr = ENV.delete "REDDIT_SECRETS" if %w{ reddit com } == URI(input).host.split(?.).last(2)
          begin
            case expectation
            when Class
              e = assert_raises expectation, "for #{input} (giveup = #{giveup})" do
                DirectLink input, 5, *ENV["PROXY"], giveup: giveup
              end
              assert_equal expectation.to_s, e.class.to_s, "for #{input} (giveup = #{giveup})"
            when String
              result = DirectLink input, 5, *ENV["PROXY"], giveup: giveup
              assert_equal expectation, result.url, "for #{input} (giveup = #{giveup})"
            else
              result = DirectLink input, 5, *ENV["PROXY"], giveup: giveup
              result = [result] unless result.is_a? Array   # we can't do `Array(<Struct>)` because it splats by elements
              assert_equal expectation, result.size, ->{
                "for #{input} (giveup = #{giveup}): #{result.map &:url}"
              }
            end
            # weird that this test may take longer than 5 sec
          ensure
            ENV["IMGUR_CLIENT_ID"] = ti if ti
            ENV["REDDIT_SECRETS"] = tr if tr
          end
        end
      end
    end

  end

  describe "./bin" do
    require "open3"

    describe "shows usage help if misused" do
      [
        [/\Ausage: directlink \[--debug\] \[--json\] \[--github\] \[--ignore-meta\] <link1> <link2> <link3> \.\.\.\ndirectlink version \d\.\d\.\d\.\d\d? \(https:\/\/github\.com\/nakilon\/directlink\)\n\z/, nil],
        [/\Ausage: directlink \[--debug\] \[--json\] \[--github\] \[--ignore-meta\] <link1> <link2> <link3> \.\.\.\ndirectlink version \d\.\d\.\d\.\d\d? \(https:\/\/github\.com\/nakilon\/directlink\)\n\z/, "-h"],
        [/\Ausage: directlink \[--debug\] \[--json\] \[--github\] \[--ignore-meta\] <link1> <link2> <link3> \.\.\.\ndirectlink version \d\.\d\.\d\.\d\d? \(https:\/\/github\.com\/nakilon\/directlink\)\n\z/, "--help"],
        [/\Ausage: directlink \[--debug\] \[--json\] \[--github\] \[--ignore-meta\] <link1> <link2> <link3> \.\.\.\ndirectlink version \d\.\d\.\d\.\d\d? \(https:\/\/github\.com\/nakilon\/directlink\)\n\z/, "-v"],
        [/\Ausage: directlink \[--debug\] \[--json\] \[--github\] \[--ignore-meta\] <link1> <link2> <link3> \.\.\.\ndirectlink version \d\.\d\.\d\.\d\d? \(https:\/\/github\.com\/nakilon\/directlink\)\n\z/, "--version"],
        ["DirectLink::ErrorBadLink: \"--\"\n", "--"],
        ["DirectLink::ErrorBadLink: \"-\"\n", "-"],
        ["DirectLink::ErrorBadLink: \"-\"\n", "- -"],
        ["DirectLink::ErrorBadLink: \"asd\"\n", "asd"],
      ].each_with_index do |(expectation, param), i|
        it "##{i + 1}" do
          string, status = Open3.capture2e "RUBYOPT='-rbundler/setup' ./bin/directlink #{param}"
          if expectation.is_a? String
            assert_equal expectation, string
          else
            assert_match expectation, string
          end
          assert_equal 1, status.exitstatus
        end
      end
    end

    # that hack around `export` is for crossplatform Travis test, since Ubuntu uses `sh` that can't `source`
    # TODO: but maybe I could make Open3 use the shell I need, since `source` works fine for `.travis.yaml`'s `:script`

    describe "fails" do
      [
        [1, "http://example.com/", /\AFastImage::UnknownImageType\n\z/],
        [1, "http://example.com/404", /\ANetHTTPUtils::Error: HTTP error #404 \n\z/],

        # TODO: a test when the giveup=false fails and reraises the DirectLink::ErrorMissingEnvVar
        #       maybe put it to ./lib tests

        # by design it should be impossible to write a test for DirectLink::ErrorAssert
        [1, "https://flic.kr/p/DirectLinkErrorNotFound", /\ANetHTTPUtils::Error: HTTP error #404 \n\z/],

        [1, "https://imgur.com/a/badlinkpattern", /\ANetHTTPUtils::Error: HTTP error #404 \n\z/],
        # TODO: a test that it appends the `exception.cause`

        [1, "https://groundingpositivity.com/2020/08/13/new-quantum-app-will-make-you-wonder-do-we-live-in-a-simulation/", (
          Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.4.0") ?
          /\ANetHTTPUtils::EOFError_from_rbuf_fill: probably the old Ruby empty backtrace EOFError exception from net\/protocol\.rb: end of file reached\n\z/ :
          /\A\S+\/net\/protocol\.rb:\d+:in `rbuf_fill': end of file reached \(EOFError\)\n/
        ) ],  # TODO: add also a test to nethttputils gem
      ].each_with_index do |(expected_exit_code, link, expected_output, unset), i| # TODO: unset is not used anymore or I have to go sleep?
        it "##{i + 1}" do
          string, status = Open3.capture2e "export #{(File.read("api_tokens_for_travis.sh") + File.read("vk.secret")).scan(/(?<=^export )\S+=\S+/).join(" ")}#{unset} && RUBYOPT='-rbundler/setup #{$-I.map{ |i| "-I #{i}" }.join " "}' ./bin/directlink #{link}"
          assert_equal expected_exit_code, status.exitstatus, "for #{link}"
          assert string[expected_output], "for #{link}"
        end
      end
    end

    valid_imgur_image_url1 = "https://goo.gl/ySqUb5"
    valid_imgur_image_url2 = "https://imgur.com/a/oacI3gl"
    [
      ["<= #{valid_imgur_image_url1}
        => https://i.imgur.com/QpOBvRY.png
           image/png 460x460
        <= #{valid_imgur_image_url2}
        => https://i.imgur.com/QpOBvRY.png
           image/png 460x460
        => https://i.imgur.com/9j4KdkJ.png
           image/png 100x100
        ".gsub(/^ {8}/, "")],
      ['[
          {
            "url": "https://i.imgur.com/QpOBvRY.png",
            "width": 460,
            "height": 460,
            "type": "image/png"
          },
          [
            {
              "url": "https://i.imgur.com/QpOBvRY.png",
              "width": 460,
              "height": 460,
              "type": "image/png"
            },
            {
              "url": "https://i.imgur.com/9j4KdkJ.png",
              "width": 100,
              "height": 100,
              "type": "image/png"
            }
          ]
        ]
        '.gsub(/^ {8}/, ""), "json"],
    ].each do |expected_output, param|
      it "#{param || "default"} output format" do
        string, status = Open3.capture2e "export #{(File.read("api_tokens_for_travis.sh") + File.read("vk.secret")).scan(/(?<=^export )\S+=\S+/).join(" ")} && RUBYOPT='-rbundler/setup' ./bin/directlink#{" --#{param}" if param} #{valid_imgur_image_url1} #{valid_imgur_image_url2}"
        assert_equal [0, expected_output], [status.exitstatus, string]
      end
    end

    it "reddit_bot gem logger does not flood STDOUT" do
      string, status = Open3.capture2e "RUBYOPT='-rbundler/setup' ./bin/directlink http://redd.it/997he7"
      assert_equal "<= http://redd.it/997he7\n=> https://i.imgur.com/QpOBvRY.png\n   image/png 460x460\n", string
    end

    # TODO: test about --json
    it "uses <meta> tag" do
      string, status = Open3.capture2e "RUBYOPT='-rbundler/setup' ./bin/directlink --json https://www.kp.ru/daily/26342.7/3222103/"
      assert_equal [0, "https://s11.stc.all.kpcdn.net/share/i/12/8054352/cr-1200-630.wm-asnplfru-100-tr-0-0.t-13-3222103-ttps-54-14-0083CD-1010-l-85-b-42.t-13-3222103-ttps-54-14-FFF-1010-l-85-b-42.t-207-5-asb-37-10-FFF-788-l-370-t-68.m2018-03-14T02-10-20.jpg"], [status.exitstatus, JSON.load(string).fetch("url")]
    end
    # TODO: kp.ru broke the page -- images are gone
    # it "ignores <meta> tag" do
    #   string, status = Open3.capture2e "RUBYOPT='-rbundler/setup' ./bin/directlink --json --ignore-meta https://www.kp.ru/daily/26342.7/3222103/"
    #   assert_equal [0, 21, "https://s11.stc.all.kpcdn.net/share/i/12/8024261/inx960x640.jpg"], [status.exitstatus, JSON.load(string).size, JSON.load(string).first.fetch("url")]
    # end

  end

end
