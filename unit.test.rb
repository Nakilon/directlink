require "minitest/autorun"
require "minitest/around/spec"
require "minitest/mock"
require "webmock/minitest"
require_relative "webmock_patch"

ENV["IMGUR_CLIENT_ID"] = "001788999ccdddf"
ENV["FLICKR_API_KEY"] = "00123333456678889bbbbcccddddddff"
ENV["REDDIT_SECRETS"] = "reddit_token.yaml"
ENV["VK_ACCESS_TOKEN"] = "0011222222233334455566667777778888888888999999aaaaaaabbbbcddddddddddddddeeeeeeeffffff"
ENV["VK_CLIENT_SECRET"] = "0011223445555555555566777777888999999999999aaaaaaabccddddddddeeefffffff"

require_relative "lib/directlink"
DirectLink.silent = true  # TODO: remove?
DirectLink.timeout = 30   # TODO: tests about this attribute

describe DirectLink do
  around{ |test| Timeout.timeout(4){ test.call } }
  before{ WebMock.reset! }

  describe "./lib" do

    describe "google" do

      # TODO: expand this for every branch in the lib
      %w{
        https_long_blogspot https://1.bp.blogspot.com/-__qsdLxNtcQ/XhaOQle-ECI/AAAAAAAABQ4/S_7SGG_abcDE6XIU2wyPvTj9OyBfr_1sQCLcBGAsYHQ/w1200-h630-p-k-no-nu/iceland_poppies_orange_flowers_field-wallpaper-3840x2160.jpg https://1.bp.blogspot.com/-__qsdLxNtcQ/XhaOQle-ECI/AAAAAAAABQ4/S_7SGG_abcDE6XIU2wyPvTj9OyBfr_1sQCLcBGAsYHQ/s0/
        http_short_blogspot http://4.bp.blogspot.com/-poH-QXn7YGg/U-3ZTDkeF_I/AAAAAAAAISE/mabcDE6-v-g/w72-h72-p-k-no-nu/Top-24-Inspired-181.jpg https://4.bp.blogspot.com/-poH-QXn7YGg/U-3ZTDkeF_I/AAAAAAAAISE/mabcDE6-v-g/s0/
        just_gplus https://lh3.googleusercontent.com/-NiGph3ObOPg/XE3DgnavXlI/AAAAAAABvgE/pcPPCe88rsU1r941wwP76TVf_abcDE6kwCJoC/w530-h353-n/DSCF0753.JPG https://lh3.googleusercontent.com/-NiGph3ObOPg/XE3DgnavXlI/AAAAAAABvgE/pcPPCe88rsU1r941wwP76TVf_abcDE6kwCJoC/s0/
        google_keep https://lh5.googleusercontent.com/fRmAL_04p7oomNHCiV4tH4-agHSDBtLaWi_Tb6bgE5ZSHVu5OjQF3iRn06nNwP3ywZwdFP92zWM-abcDE6n6m0tDTBARuO6F9e0wYu_1=s685 https://lh5.googleusercontent.com/fRmAL_04p7oomNHCiV4tH4-agHSDBtLaWi_Tb6bgE5ZSHVu5OjQF3iRn06nNwP3ywZwdFP92zWM-abcDE6n6m0tDTBARuO6F9e0wYu_1=s0
      }.each_slice 3 do |name, link, o|
        it "replaces s0 and schema correctly #{name}" do
          assert_equal o, DirectLink.google(link)
        end
      end

      describe "does not fail" do
        # TODO: also check the #google is being called

        "
           1 //1.bp.blogspot.com/-rYk_u-qROQc/WngolJ8M0LI/AAAAAAAAD-w/abcDE6IVzasBPG5C2T1t-VrWKRd_U6lMgCLcBGAs/w530-h278-p/i-469.jpg
           2 //4.bp.blogspot.com/-1RlHbRShONs/Wngp9WfxbfI/AAAAAAAAD-8/abcDE6SZdvUMz4VjJPBpprLBrJ5QpBaqACLcBGAs/w530-h278-p/i-468.jpg
           3 //4.bp.blogspot.com/-5kP8ndL0kuM/Wpt82UCqvmI/AAAAAAAAEjI/abcDE60-kgwRXEJ9JEGioR0bm6U8MOkvQCKgBGAs/w530-h278-p/IMG_20171223_093922.jpg
           4 //4.bp.blogspot.com/-bS1SZxFkvek/Wnjz3D5Il4I/AAAAAAAAD_I/abcDE6GB7r4NGJ0aR1F-ugsbVm4HUjf5ACLcBGAs/w530-h278-p/i-466.jpg
           5 //lh3.googleusercontent.com/-1CF2jge1MYI/Wmr_kfCQQUI/AAAAAAAClKs/abcDE64v0q0i5N7rgso6G8SrhJNzsHEagCJoC/w530-h352-p/2809525%2B%25D0%2593%25D0%2590%25D0%259B%25D0%259E%2B%25D0%259F%25D0%2590%25D0%25A0%25D0%2593%25D0%2595%25D0%259B%25D0%2598%25D0%2599%2B-%2B%25D0%25A7%25D0%25A3%25D0%259A%25D0%259E%25D0%25A2%25D0%259A%25D0%2590%2B-%2B%25D0%25AE%25D0%25A0%25D0%2598%25D0%2599%2B%25D0%25A5%25D0%2590%25D0%25A0%25D0%25A7%25D0%2595%25D0%259D%25D0%259A%25D0%259E.jpg
           6 //lh3.googleusercontent.com/-h1siEcRFqJ8/Wiv1iDQhNVI/AAAAAAAAQV4/abcDE6mYkDMLyVTG_1EBCMmj-UhmclXWwCJoC/w530-h353-p/001
           7 //lh3.googleusercontent.com/-qnZygRb-Tn8/Wlyj4UuKbaI/AAAAAAAATqE/abcDE6-XBZwsh843xJ3cSd0JPt1LedU9gCJoC/w530-h330-p/001
           8 //lh3.googleusercontent.com/-rXO9PzbjNmk/WlNfjJkJBmI/AAAAAAAATNY/abcDE6tWBzUKWufNXWkK82etw3RKA6jVgCJoC/w530-h361-p/001

          13 //lh3.googleusercontent.com/proxy/2fsWfEOeeCMNEP8MGvHiJPkBlg47Ifaf8DwpgDPJSPSYsh9iomTrfOA9OuwB60laZimtNr4-1GKA5J2csuVB6-1DLNO30K-abcDE656ivICWRFAUuOwzizaztBx5gQ=w530-h707-p
          14 //lh3.googleusercontent.com/proxy/2qy3gOwhBT77Ie_qa9VgGz6kgN14tnOh1AMmV9FB65oiXOSAIll1_qmOZdupL3QCcJQL4701YskEgeDUnxJTnFGq4mFEzNFvjpNC-QMX9Jg7mdar3e89u_siA4AD-j1SJ6mrkl2MwSJSu1s2guYn0NR5ND1985lK34_iGiwzjoGHG2a65IbxKDSEzgSGbPQ_abcDE6BIvfcgvAxtS6E=s530-p
          28 //lh3.googleusercontent.com/proxy/7N0QCidzIFysO6OhmrG8twRJ74-sboNenI3Nhy3mIWP8C0SSa8J6xFQU3iyBTw4k3QeleiAgXOME3abYutPvBrHGx-0TBUcI-_abcDE69Zaw6PAGdLndkxp5ReRJnsg=w530-h298-p
          31 //lh3.googleusercontent.com/proxy/7pN3aTE159nEXXQb_KajU1vcnDDzJVpGOv9vlWWPd3CbVuCKu-v4ndr423Mmhx-Zn5vqkVf6-TfZgPA5NyHECsr4w7kaw1jTmQDJbWO-9jU-Cs7ywrzcIRhyYTTZT-abcDE6wI1oEdbooIk=w464-h640-p
          48 //lh3.googleusercontent.com/proxy/DZtTi5KL7PqiBwJc8weNGLk_Wi2UTaQH0AC_abcDE6iu0AbwyI2ywOk2XgdAjL7ceg=w530-h354-n
          74 //lh3.googleusercontent.com/proxy/P4FQdTYwWN8cU_PWmFja1cm3oYu57L_flea7LmKvFjx0Ibdxl3glxcp-abcDE6xMFTQ3gQkWsWzlrkyCm9QrSjCUcGIgnbsYBCXewnhEwSn0ZgT4XDg485GdXMoGWpNETrLYa8IGvG20_iw=w504-h597-p
         137 //lh3.googleusercontent.com/proxy/kX1ABK6_VjHDU12p-zZN6ciTOzqFcXm7IV41uR9F2sveM2t148nmWBEN1clA-VHvowpkd9T4NOPrAfDaip1o-jJBtBnRBElJuCsKo8FviSIkToZWCY9nQFEj06nHkMNuReBtdbVBlIRSodNJM-_cmqiJ-DnmWNe4dk62EF_kGLS28OWmckDLWVG0YFiZ-lVi8JhgR-ZgRmYWTs8bb_u6v6ucgfo8eh7ewchuZAD9_CoxUlQChAqz0QIfuVuKvmcXE06Ylv2H330btswQotjKDf8AXPe6xcyE9X1JXDYQTsPv-7lftLG9WQp1Mlc9Wu1XbHV7f541L-smt--7YpkW6fbDFYk4_87-pIOcg9UqHKB__DWyMCtH3gs8rv6VCmVwL1a-oAeBWSWk0Tc9R6uSuyCjt0nEBGlZY35aW1Pchz0jXr4lq8Il9m-wbRN9E7Kff1JR89YFOrV2N86w_72YTefFerLFfEsgzmhx3WYwok-abcDE6H7MyiHBQt04uRnb58GA4vl5VBQ=w530-h398-p

         245 https://lh3.googleusercontent.com/-2JzV0ErXvv8/Wsdr-m5Q_aI/AAAAAAAA_-I/Lw_e6qEMPUck4yW9yWhkC-abcDE6m8c3QCJoC/w530-h795-n/888052_800n.jpg
         346 https://lh3.googleusercontent.com/-8YmBt-SUaJo/War0Un_7YTI/AAAAAAAB9xs/kgXp9QrHZX8mpDfyLwuS9cabcDE6oH6NgCL0BGAs/w530-d-h443-n/%25D0%259B%25D0%25B5%25D1%2581%2B%25D0%25BD%25D0%25B0%2B%25D0%25B8%25D1%2581%25D1%2585%25D0%25BE%25D0%25B4%25D0%25B5%2B%25D0%25BB%25D0%25B5%25D1%2582%25D0%25B0.JPG
        1317 https://lh3.googleusercontent.com/-tGAyJv4S6gM/WSLy4A7AFaI/AAAAAAABxk4/eq0Aprp2koM6GEti9xEIn-abcDE6bRRdQCL0B/w530-d-h660-n/%25D0%2592%25D0%25B5%25D1%2581%25D0%25BD%25D1%258B%2B%25D1%2586%25D0%25B2%25D0%25B5%25D1%2582%25D0%25B5%25D0%25BD%25D0%25B8%25D0%25B5.JPG

         178 https://lh3.googleusercontent.com/--Ggbfs9HJZM/Wog1DA2WcFI/AAAAAAAAbdQ/SZKPcnabcDE6Ffl9pddfiLPQnOiJ37muQCJoC/w409-h727-n/11a1c54f37c07d3c04588b40d108b4c2.jpg
         260 https://lh3.googleusercontent.com/-3Fe6CL9RH4o/WnipWY4889I/AAAAAAAAI4I/CPqdKpabcDE6aBlCqGQ3RdZ9bLJ4nzBwwCJoC/w239-h318-n/gplus1855963830.jpg
         303 https://lh3.googleusercontent.com/-5vPhLnUILsA/WqFhJhu7VlI/AAAAAAAAAhQ/wWSrC8abcDE6OuzeU3UoXJkNG19tqtAGwCJoC/w265-h353-n/DSC08260.JPG
         668 https://lh3.googleusercontent.com/-NLW68hNxEzU/WrSNfBxFX2I/AAAAAAAAAT8/7cvRM-abcDE6dlb6CS8pL5-eJ3wbwohlQCJoC/w179-h318-n/23.03.2018%2B-%2B3
         669 https://lh3.googleusercontent.com/-NVJgqmI_2Is/WqMM2OMYg-I/AAAAAAAALrk/5-p3JLabcDE6o9dOf_p3gpddzqwr3Wp0ACJoC/w424-h318-n/001
         783 https://lh3.googleusercontent.com/-SqAvt_F__bg/Wq0huHcX2NI/AAAAAAAAVj0/XfnwCUabcDE60Knw8rcXA-bhpKYkI4hdwCJoC/w358-h318-n/IMG_20180317_120218-01-01.jpeg
         830 https://lh3.googleusercontent.com/-VB3YlLVL_tQ/Wo21yTbKl_I/AAAAAAAAApU/3DURmsabcDE60kif2ZRjhoLG4mTHYf8OwCJoC/w254-h318-n/180218_00001.jpg
        1002 https://lh3.googleusercontent.com/-d8FkfLWq-_4/WpQXzEfFgBI/AAAAAAAADww/J32xKSabcDE6c3pyrZnNmRec6kjdnJBHgCJoC/w239-h318-n/gplus-485739203.jpg
      ".scan(/(\S+) (\S+)/).each do |i, link|   # some pre-May-2018 urls dump from a community
        it "Google Plus community post image ##{i}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh3.googleusercontent.com/-abcDE62vWuE/AAAAAAAAAAI/AAAAAAAAAAQ/wVFZagieszU/w530-h176-n/photo.jpg
        //lh3.googleusercontent.com/abcDE6v7EGo0QbuoKxoKZVZO_NcBzufuvPtzirMJfPmAzCzMtnEncfA7zGIDTJfkc1YZFX2MhgKnjA=w530-h398-p
        //lh3.googleusercontent.com/-0Vt5HFpPTVQ/Wnh02Jb4SFI/AAAAAAAAbCU/MtusII6-abcDE6QWofAaWF01IBUVykMyACJoC/w530-h351-p/DSC_3804%2B-%2B%25D0%25BA%25D0%25BE%25D0%25BF%25D0%25B8%25D1%258F.JPG
        https://lh3.googleusercontent.com/-abcDE6-b85c/WvOtHJn-DxI/AAAAAAAAAKg/A_PoO64o0VkX1erPKebiO7Xcs5Iy3idbACJoC/w424-h318-n/IMG_20180510_082023.jpg
        https://lh3.googleusercontent.com/-abcDE6FntJY/Wvl8HLwfF_I/AAAAAAAAA20/mqOtMCFuBkkvtv7jdpVkJv2XSXlOLoXVQCJoC/w212-h318-n/DPP_0006.JPG
        https://lh3.googleusercontent.com/-abcDE64EIiw/WuxqzXHQCHI/AAAAAAAABAI/rA0R2UsbxoswvH6nSePnwa5VHG2f5kNOQCJoC/w398-h318-n/Fox-Desktop-1024x1280.jpg
        https://lh3.googleusercontent.com/-abcDE62-1OA/WvMUBWXI0PI/AAAAAAAAC60/gdtkQz9YI0knYkFB8VjC2CpKOD6-Zs6hQCJoC/w408-h318-n/%25D0%25BF%25D0%25BE%25D1%2581.jpg
        https://lh3.googleusercontent.com/--abcDE6Gk-A/WveQe_YKbAI/AAAAAAAACkQ/eTz2maXvw7A0iKoPjfuwEgfTiZS3a3HSgCJoC/w318-h318-n/gplus1165736192.jpg
        https://lh3.googleusercontent.com/-abcDE6hwMOg/WtOxVJ1DNxI/AAAAAAAAMGs/pJf8awKJcyMFlx2g89p9_QjqlyQDmYMmACJoC/w424-h318-n/DSC03178.JPG
        https://lh3.googleusercontent.com/-abcDE67fY1o/WtaUJCaDGmI/AAAAAAAAmBQ/jZhatiBmHPEiAAABcY2DoJ6KuzVBvqGxQCJoC/w530-h150-n/%25D0%25A1%25D0%25BD%25D0%25B8%25D0%25BC%25D0%25BE%25D0%25BA%2B%25D1%258D%25D0%25BA%25D1%2580%25D0%25B0%25D0%25BD%25D0%25B0%2B2018-04-18%2B%25D0%25B2%2B3.32.42.png
        https://lh3.googleusercontent.com/-40QwR_c58sw/WsLyS3a8uhI/AAAAAAAAAas/ojaQoF1-abcDE6S6c5kLs7bOl_TAOU6oACJoC/w424-h318-n/271091.jpg
        https://lh3.googleusercontent.com/-abcDE6yNBjY/WvOtHOyaj_I/AAAAAAAAAKo/gOAn__a75NwYSgaBaEBGeCTAFI9MyjqlwCJoC/w239-h318-n/IMG_20180510_081956.jpg
        https://lh3.googleusercontent.com/-R19p_abcDE6/Wwma1oEvD6I/AAAAAAAAEX8/tQc4JOq58REEWlukw2jDCTUjH3ejGZI8gCJoC/w486-h864-n/gplus1392977354.jpg
        //2.bp.blogspot.com/-mOnRg-mkojA/W22m79XcT_I/AAAAAAAAHDs/C8yQaOA-ZeEAr3WBG--abcDE65nWV0p7QCEwYBhgL/w530-h353-p/_MG_8809-Edit.jpg
      }.each_with_index do |link, i|  # March contenstants
        it "another (March) Google Plus community post image ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh3.googleusercontent.com/-abRcDE6_gic/WwUz3_Www7I/AAAAAAAABio/MNYvB57tBvIl6Bxp0GsKHvg0hSyHyVWhwCJoC/w265-h353-n/IMG_20180522_210620_317.jpg
        https://lh3.googleusercontent.com/-abAcDE61QVc/Wu4Khtduz-I/AAAAAAAAA_A/lvpwTuatrtkhL31co1n9xa7kwKEVwc6IwCJoC/w301-h318-n/gplus662578195.jpg
        https://lh3.googleusercontent.com/-abKcDE6NG2Q/Wvt9mUDC1QI/AAAAAAAANEw/2uWvIzQmG-Y3CGHuB8-UU114z4Zr8lkLQCJoC/w530-h175-n/PANO_20180516_025747.jpg
        https://lh3.googleusercontent.com/-abWcDE66_Ew/WwvJcNQ39BI/AAAAAAAABvI/xb1bdwuEZGM2SmbwamwiMmZKFOW44bhPgCJoC/w239-h318-n/DSC03627.JPG
        https://lh3.googleusercontent.com/-abacDE67WWI/Wu4Khq0IkaI/AAAAAAAAA_A/Dxs9JYJ6f6sv_7jNWMdNl3eo2jh9nYqDwCJoC/w296-h318-n/gplus-328480287.jpg
        https://lh3.googleusercontent.com/-ab3cDE6qjyo/Wu4Khr5ZKhI/AAAAAAAAA_A/725HNeKw2hYtuddakPreAkaucQR6HOYGgCJoC/w424-h318-n/20180317_085037.jpg
        https://lh3.googleusercontent.com/-abYcDE6GABY/Wu4Khov2uGI/AAAAAAAAA_A/xFVaLt1emxUtOvys7Mw8QZIF2599lNV6ACJoC/w424-h318-n/20180317_085508.jpg
        https://lh3.googleusercontent.com/-abMcDE6jtXg/Wu4KhkZD9nI/AAAAAAAAA_A/lBHtrho7HBQgkZNztMTdR3o1RSu47OnigCJoC/w239-h318-n/gplus1795981938.jpg
        https://lh3.googleusercontent.com/-ab-cDE6kT88/Wu4Khs76OSI/AAAAAAAAA_A/2rsXBfNM4Isi3YBNWlgLnPgQpVN72dXiQCJoC/w318-h318-n/gplus-379421668.jpg
      }.each_with_index do |link, i|  # April contenstants
        it "another (April) Google Plus community post image ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh3.googleusercontent.com/-abcDE6XoL_k/WvMUBQ6TXMI/AAAAAAAAC60/XRgJlEr5hbgKzYzOQkM8b4_fq2Yp5vNbACJoC/w239-h318-n/%25D0%25B7%25D0%25B0%25D1%2581.jpg
        https://lh3.googleusercontent.com/-abcDE6ZYF4Y/Wvl8HH7crSI/AAAAAAAAA20/0vaXtOyqDL0DLx841Gj45ePol01OCOAewCJoC/w212-h318-n/DPP_0007.JPG
        https://lh3.googleusercontent.com/-abcDE6DAoH8/WyCS3fapzjI/AAAAAAAAB5M/hKzS0cR0MEgnM-YJENsL7dX8Tbch5Z04wCJoC/w265-h353-n/DSC03805.JPG
        https://lh3.googleusercontent.com/-abcDE6hweSI/WvMUBS4uAJI/AAAAAAAAC60/tE7aakvztZgTqvRMcrk2FbrauU8LLhGPgCJoC/w239-h318-n/11.jpg
        https://lh3.googleusercontent.com/-abcDE6T_v6g/WyCS3VJ-hVI/AAAAAAAAB5M/qeUFKiNXnwkJ-q2q2VoM2f9ukTqPOGhAACJoC/w265-h353-n/DSC03807.JPG
        //2.bp.blogspot.com/-abcDE6kbjOk/WwlXLbeiF9I/AAAAAAAAKKE/zT7sAlaNYIc7lTxZMY1tyND0u3UH5DuKACLcBGAs/w530-h398-p/EdnjF3yEMM8.jpg
        https://lh3.googleusercontent.com/-1_J-abcDE6E/Wx9lWOEXUjI/AAAAAAAAB34/183rqDWZipkaSWyV6qF_Fm7_XQrtYiwdACJoC/w265-h353-n/DSC03800.JPG
        https://lh3.googleusercontent.com/-I72-abcDE64/Wx9lWLfINqI/AAAAAAAAB34/EIOySV-4ny8xMECMSC4TvHV43qUn0HLLwCJoC/w265-h353-n/DSC03797.JPG
        https://lh3.googleusercontent.com/-L-RnabcDE6I/WxZnv-NRXWI/AAAAAAAARVw/Z3yVnOEDU7kDZ-WbRoLbEh8Tao1_DtQbACJoC/w179-h318-n/20160305_134926.jpg
        //lh3.googleusercontent.com/-abcDE6HFM6E/WtRMPtqimXI/AAAAAAAACIo/txJyaoEvnEQu7r2-35SgwFYCWHGmXDQ3QCJoC/w530-h353-p/IMG_3695.jpg
      }.each_with_index do |link, i|  # May contenstants
        it "another (May) Google Plus community post image ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh3.googleusercontent.com/-dWul1-dnMGE/W1npdlvSenI/AAAAAAAAAJI/abcDE65xS98xvFJDNgMgcxrRzPd6gOp9QCJoC/w208-h318-n/alg3_1520-2.jpg
        https://lh3.googleusercontent.com/-t_ab__91ChA/VeLaObkUlgI/AAAAAAAAL4s/abcDE6_lkRw/w530-h351-n/30.08.15%2B-%2B1
        https://lh3.googleusercontent.com/-Ry3uDLjGG0E/W13DzrEntEI/AAAAAAAAAdY/abcDE6-2JPsnuqYq7qtif_eVWhTd0EmnwCJoC/w480-h853-n/gplus-790559743.jpg
      }.each_with_index do |link, i|  # June contenstants
        it "another (June) Google Plus community post image ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh3.googleusercontent.com/-s655sojwyvw/VcNB4YMCz-I/AAAAAAAALqo/abcDE6cJJ0g/w530-h398-n/06.08.15%2B-%2B1
        //4.bp.blogspot.com/-TuMlpg-Q1YY/W3PXkW1lkaI/AAAAAAAAHHg/Bh9IsuLV01kbctIu6lcRJHKkY-abcDE6gCLcBGAs/w530-h353-p/_MG_2688-Edit.jpg
        //lh3.googleusercontent.com/proxy/SEfB6tFuim6X0HdZfEBSxrXtumUdf4Q4y05rUW4wc_clWWVrowuWAGZghx71xwPUmf_abcDE6wnRivsM7PfD2gp3kA=w480-h360-n
        https://lh3.googleusercontent.com/-u3FhiUTmLCY/Vk7dMQnxR2I/AAAAAAAAMc0/I76_abcDE6s/w530-h322-n/Harekosh_A%252520Concert_YkRqQg.jpg
        https://lh3.googleusercontent.com/-t_ab__91ChA/VeLaObkUlgI/AAAAAAAAL4s/abcDE6_lkRw/w530-d-h351-n/30.08.15%2B-%2B1
        //lh3.googleusercontent.com/-u2NzdIQfVyQ/Wy83AzoFT8I/AAAAAAAAh6M/fdpxOUkj5mUIfpvYol_abcDE6nF2nDIEACJoC/w530-h298-p/_DSC9134.jpg
      }.each_with_index do |link, i|  # July contenstants
        it "another (July) Google Plus community post image ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh3.googleusercontent.com/-f37xWyiyP8U/WvmxOxCd-0I/AAAAAAAACpw/3A2tRj02oY40MzJqZBJyWabcDE6r0lwMgCJoC/s0/140809%2B029.jpg
        https://lh3.googleusercontent.com/-1s_eiQB4x2k/WvXQEx59z2I/AAAAAAAAcI0/DvKYzWw3g6UNelqAQdOwrabcDE6qKgkxwCJoC/s0/001
        https://lh3.googleusercontent.com/-1Rcbffs4iRI/WvaSsRCrxJI/AAAAAAAAcJs/e-N9tmjaTCIxEBE_jXwFjabcDE6Fwh4owCJoC/s0/001
        https://lh3.googleusercontent.com/-VXUjuSl-dZY/WvK340_E9uI/AAAAAAAAVlg/HqKf1LgUcPUJNrLxHebCMabcDE6q36_bQCJoC/s0/gplus248254159.jpg
        https://lh3.googleusercontent.com/-NlZRwcX_Lj8/WvQTijeAfJI/AAAAAAABNyo/jgoDgbZdTvsnLOGmmYlXMabcDE6ieZV4QCJoC/s0/67u8iii.png
        https://lh3.googleusercontent.com/-8baBz80pf8Y/Wu8KG5lyGhI/AAAAAAACSyU/s3hasZzObK0VlntA1EBj-abcDE6gzRnLQCJoC/s0/%25D0%2592%25D0%25B5%25D1%2581%25D0%25B5%25D0%25BD%25D0%25BD%25D0%25B8%25D0%25B5%2B%25D0%25BA%25D1%2580%25D0%25B0%25D1%2581%25D0%25B0%25D0%25B2%25D1%2586%25D1%258B.JPG
        https://lh3.googleusercontent.com/-BBjhu17YIgg/W-gnZNaZeMI/AAAAAAABA-k/UMlSbNuE0DsSEPV8u3yf_abcDE69vFoBgCJoC/s0/gplus320347186.png
      }.each_with_index do |link, i|
        it "already high res image ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh3.googleusercontent.com/-5USmSTZHWWI/WMi3q1GdgiI/AAAAAAAAQIA/lu9FTcUL6xMw4wdoW_I148Vm1abcDE6mwCJoC/w346-h195-n-k-no/Good%2BJob.gif
        https://lh3.googleusercontent.com/-G8eSL3Xx2Kc/WxWt9M6LptI/AAAAAAAAB_c/KNF9RBxjL04Reb3fBtwYLI2AlabcDE67gCJoC/s0/20180602212016_IMG_0244.JPG
        https://lh3.googleusercontent.com/-aUVoiLNsmAg/WzcsUU2xfNI/AAAAAAAAODw/DOBual6E1rkVLHh3SKZSzbpNQabcDE6OQCJoC/w530-h883-n-k-no/gplus-1797734754.mp4
        //lh3.googleusercontent.com/proxy/hOIoIpMEmoVDSP40VRzM92Zw2AeLvEEhxfyKHCOxiNVPyiGvZik5rMvl3jYISLabcDE6mhZuk8pFEYJhX5BU2wy_dw=w530-h822-p
        https://lh3.googleusercontent.com/-GP3BA3zGR5A/W0IwuVXlfmI/AAAAAAADROs/SH8rRlBDYTsHZiHpM45S3zpEiabcDE6PwCJoC/s0/%25D1%2582%25D0%25B0%25D0%25B4%25D0%25B6%25D0%25B8%25D0%25BA%25D1%2581%25D0%25BA%25D0%25BE%25D0%25B5%2B%25D1%2580%25D0%25B0%25D0%25B7%25D0%25BD%25D0%25BE%25D1%2582%25D1%2580%25D0%25B0%25D0%25B2%25D1%258C%25D0%25B5.png
        https://lh3.googleusercontent.com/-DLODAbD9W7E/W27ob5XGCOI/AAAAAAADV8g/J_6RYR6UkKsc2RJOWRx6Q-NBVabcDE6xwCJoC/s0/1236080.jpg
        https://lh3.googleusercontent.com/-cJajRreI87w/W4gW5uF4Q7I/AAAAAAADZKI/mw1YayYE-MY2-1OCCmjvgM3kbabcDE6ggCJoC/s0/2504855.jpg
        https://lh3.googleusercontent.com/-rm-m1meCOMY/W92GhExMG-I/AAAAAAADsTw/bIAm5-1CIOYEpyPJLnxT8VmI_abcDE6dACJoC/s0/2659806_800n.jpg
        https://lh3.googleusercontent.com/-z1nwsq4NOT4/XETT5qhXP-I/AAAAAAAAC0s/03kJ22drB1EdqZ97gUXCPHkLZabcDE6OACJoC/w530-h942-n/gplus1629127930.jpg
        https://lh3.googleusercontent.com/-NiGph3ObOPg/XE3DgnavXlI/AAAAAAABvgE/pcPPCe88rsU1r941wwP76TVf_abcDE6kwCJoC/w530-h353-n/DSCF0753.JPG
        https://lh3.googleusercontent.com/-QfChCi9Lj6A/XEciVlXmDhI/AAAAAAACuZw/iYzoMIxr7SsGzEFbk1LrqIdCdabcDE6HACJoC/w795-h1193-n-rw/z7765765765757575.jpg
      }.each_with_index do |link, i|
        it "gpluscomm_105636351696833883213_86400 ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://4.bp.blogspot.com/--L451qLtGq8/W2MiFy8SVCI/AAAAAAAARgM/9qr4fr2PiV8IE4dabcDE6dEnlchx1V6vwCLcBGAs/w72-h72-p-k-no-nu/blood_moon_5k.jpg
        https://3.bp.blogspot.com/-aZETNznngSo/W2xbe673_6I/AAAAAAAARhs/hkXvEk85ol4SqVeabcDE6uDGLyT4V45kACLcBGAs/w72-h72-p-k-no-nu/waterfall-1280x800-ireland-4k-19245.jpg
        https://3.bp.blogspot.com/-ZmCuJkPliO8/W3WjIWvdjXI/AAAAAAAARi4/qO9I8kzJvCMRWsgabcDE6cOCQPCyu_xDQCLcBGAs/w72-h72-p-k-no-nu/ford_mustang_neon_lights_5k.jpg
        https://2.bp.blogspot.com/-rb2PXLGZy0s/W2nQe3mXOSI/AAAAAAAARhQ/P8gV-bMtYbY2xxpabcDE6xu3XDTUaugxQCLcBGAs/w72-h72-p-k-no-nu/beach-bora-bora-clouds-753626.jpg
        https://1.bp.blogspot.com/-FGnZn0040os/W3g7wnT2o-I/AAAAAAAARjE/xfgcR4fyvQgBgV5abcDE6YOVK4d4dTouwCLcBGAs/w72-h72-p-k-no-nu/axl_2018_movie_4k_8k-7680x4320.jpg
        https://1.bp.blogspot.com/-h9kL603XSgY/XCe5rYiOczI/AAAAAAAARmY/qz_kMyR1q-scfs-abcDE6of_QocYK7RegCLcBGAs/w72-h72-p-k-no-nu/spider_man_into_the_spider_verse_hd_4k.jpg
        https://2.bp.blogspot.com/-rb2PXLGZy0s/W2nQe3mXOSI/AAAAAAAARhQ/P8gV-bMtYbY2xxpabcDE6xu3XDTUaugxQCLcBGAs/s640/beach-bora-bora-clouds-753626.jpg
        http://4.bp.blogspot.com/-poH-QXn7YGg/U-3ZTDkeF_I/AAAAAAAAISE/abcDE6b-v-g/w72-h72-p-k-no-nu/Top-24-Inspired-181.jpg
        http://1.bp.blogspot.com/-iSU4orVuR9Y/VFYrwQZ5qYI/AAAAAAAAMnc/abcDE6aeplw/w72-h72-p-k-no-nu/Wolf%2Bphotography2.jpg
        http://1.bp.blogspot.com/-vPQSh6RKijU/VEi7r3D-jJI/AAAAAAAAL2Q/abcDE6oDp5M/w72-h72-p-k-no-nu/Building%2BIn%2BLondon1-4__880.jpeg
        http://1.bp.blogspot.com/-W4xKJSsVf3M/Uz73jPlctbI/AAAAAAAAGz4/abcDE6ILMeY/w72-h72-p-k-no-nu/Beautiful+Japanese+places4.jpg
        https://1.bp.blogspot.com/-__qsdLxNtcQ/XhaOQle-ECI/AAAAAAAABQ4/S_7SGG_K8eQ7abcDE6yPvTj9OyBfr_1sQCLcBGAsYHQ/w1200-h630-p-k-no-nu/iceland_poppies_orange_flowers_field-wallpaper-3840x2160.jpg
        https://lh3.googleusercontent.com/-tV86KJvppss/XE2Nb2Z2aAI/AAAAAAAAGu4/94E_abcDE6AaJ59n43wmmd9rFa--OUuSQCJoC/w530-h338-n/IMG_6845%252C.png
        https://lh3.googleusercontent.com/-cr-2ZSQGMPg/XFWLfetwr7I/AAAAAAAAQQQ/TbwDabcDE6wb4IDDO0SwfArFSZyDG0i0wCJoC/w530-h360-n/DSC07294.JPG
        https://lh3.googleusercontent.com/-7ey25Wg_cQ4/X-Xy8LJPjMI/AAAAAAAAALE/raXQabcDE6EzEDfAg3TcsOU_xc9z4szcwCLcBGAsYHQ/w1200-h630-p-k-no-nu/1608905381407960-0.png
      }.each_with_index do |link, i|
        it "largeimages ##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        //lh3.googleusercontent.com/proxy/S-Z1P92Dd_u0DjYrz5Tb7j0mbZsGjPVffx9lHPQZCqqCFr6vAigCPOG0fEYKU6d-wIvwYr2WriAfh97KjBr9Bq1RKgyHzHq2fpAotTnJYOLd3x_abcDE6GBVuAewE7qp2QDtCYyomyn3dGjZ6cKUnYIC8w=s110-p-k
      }.each_with_index do |link, i|
        it "posted_website_preview_##{i + 1}" do
          assert DirectLink.google link
        end
      end
      %w{
        0 https://lh3.googleusercontent.com/-okfIabcDE6g/AAAAAAAAAAI/AAAAAAAAZa0/FEv9H8woCBg/s30-p-rw-no/photo.jpg
        7 https://lh3.googleusercontent.com/-okfIabcDE6g/AAAAAAAAAAI/AAAAAAAAZa0/FEv9H8woCBg/s75-p-rw-no/photo.jpg
        _ https://lh3.googleusercontent.com/-bhgxabcDE6I/AAAAAAAAAAI/AAAAAAAA4MI/_KuKE-Goa7E/s35-p-k-rw-no/photo.jpg
        - https://lh3.googleusercontent.com/-tl9-abcDE6Y/AAAAAAAAAAI/AAAAAAAA8uY/vVeZX8SbTXI/s35-p-k-rw-no/photo.jpg
        4 https://lh3.googleusercontent.com/-Rb83abcDE64/AAAAAAAAAAI/AAAAAAAAEJc/DawCLQGnaSA/s45-p-k-rw-no/photo.jpg
      }.each_slice 2 do |i, link|
        it "Google Plus userpic #{i}" do
          assert DirectLink.google link
        end
      end
      %w{
              - https://lh3.googleusercontent.com/-abcDE6oWuoU/AAAAAAAAAAI/AAAAAAAAl90/ed314-fNMGg/s20-c-k-no/photo.jpg
           just https://lh5.googleusercontent.com/-abcDE6YpZzU/AAAAAAAAAAI/AAAAAAAAAO4/WISrqFs1vT8/s46-c-k-no/photo.jpg
          no-no https://lh5.googleusercontent.com/-abcDE6MkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/s64-c-k/photo.jpg
        no-k-no https://lh3.googleusercontent.com/-abcDE66JAgg/AAAAAAAAAAI/AAAAAAAAAAA/AIcfdXD1lA9yGoSbsihWmGfnl6Z3Rn43WA/s64-c-mo/photo.jpg
              _ https://lh6.googleusercontent.com/-abcDE6PRFk4/AAAAAAAAAAI/AAAAAAAAAAA/AIcfdXDBweE5VzGGy4zMraO_pqiLuFN3yQ/s46-c-k-no-mo/photo.jpg
      }.each_slice 2 do |i, link|
        it "Hangout userpic #{i}" do
          assert DirectLink.google link
        end
      end
      %w{
        https://lh4.googleusercontent.com/abcDE6lyjNKXqSqszuiCgPMi7_oE5fVv1Sw373HXBYlguP8AnIPAqefTS6DbBuurVGYRSxGrtDyKei1hae9Djf6rjiwjJd0aauA5Bg-z=s615
        https://lh5.googleusercontent.com/fRmAL_04p7oomNHCiV4tH4-agHSDBtLaWi_Tb6bgE5ZSHVu5OjQF3iRn06nNwP3ywZwdFP92zWM-abcDE6n6m0tDTBARuO6F9e0wYu_1=s685
        https://lh5.googleusercontent.com/FcYUQBKLXWtFLEvbQduvu7FHUm2f7U_MVdMBVnNbpwfzKHIU-xABkudxw-abcDE60jFYRHedh7Is5Dg6qlgIQF1iSndlWjiKCTTsUo1w=s1080
        https://lh5.googleusercontent.com/gcDb3dxbch9jUKPzKGawJiwtHcNS9wp6o2sc0aJj9wOWQA-u8kXmKIrZ-abcDE6ee6qLaT2p6OK2N7klTJ9CxU66OnpBhYJMg0q9QEdq5Q=s2160
      }.each_with_index do |link, i|
        it "google keep ##{i + 1}" do
          assert DirectLink.google link
        end
      end

      end

    end

    describe "imgur" do

      %w{
        https://imgur.com/a/badlinkpattern
        http://example.com/
        https://imgur.com/gallery/abcD5.
      }.each_with_index do |url, i|
        it "ErrorBadLink_##{i + 1}" do
          assert_raises DirectLink::ErrorBadLink do
            DirectLink.imgur url
          end
        end
      end

      it "ErrorNotFound when album is empty" do
        stub_request(:head, "https://api.imgur.com/3/album/abcDEF7/0.json")#.to_return(status: 200, body: "", headers: {})
        stub_request(:get, "https://api.imgur.com/3/album/abcDEF7/0.json").to_return body: {data: {images: {}}}.to_json
        e = assert_raises DirectLink::ErrorNotFound do
          DirectLink.imgur "https://imgur.com/a/abcDEF7"
        end
        assert_nil e.cause if Exception.instance_methods.include? :cause  # Ruby 2.1
      end

      valid_imgur_image_url_direct = "https://i.imgur.com/abcDEF7.jpg"
      valid_imgur_image_url_album = "https://imgur.com/a/abcDEF7"
      [400, 500, 503].each do |error_code|
        [
          [valid_imgur_image_url_direct, :direct],
          [valid_imgur_image_url_album, :album],
        ].each do |url, kind|
          it "retries a limited number of times on error #{error_code} (#{kind})" do
            tries = 0
            e = assert_raises DirectLink::ErrorAssert do
              NetHTTPUtils.stub :request_data, ->*{ tries += 1; raise NetHTTPUtils::Error.new "", error_code } do
                DirectLink.imgur url, 1.5
              end
            end
            assert_equal error_code, e.cause.code if Exception.instance_methods.include? :cause  # Ruby 2.1
            assert_equal 2, tries
          end
        end
      end
      it "does not throw 400 after a successfull retry" do
        stub_request(:head, "https://api.imgur.com/3/image/abcDEF7/0.json")
        stub_request(:get, "https://api.imgur.com/3/image/abcDEF7/0.json").to_return body: {data: {width: 100, height: 200, type: "image/jpeg", link: "https://i.imgur.com/abcDEF7.jpg"}}.to_json
        f = 0
        m = NetHTTPUtils.method :request_data
        NetHTTPUtils.stub :request_data, lambda{ |*args|
          raise NetHTTPUtils::Error.new "", 400 if 1 == f += 1
          m.call *args
        } do
          assert_equal [[valid_imgur_image_url_direct, 100, 200, "image/jpeg"]],
            DirectLink.imgur(valid_imgur_image_url_direct, 1.5)
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

      [
        ["gifv"                  , "http://i.imgur.com/abcDEF7.gifv",        "https://api.imgur.com/3/image/abcDEF7/0.json",   {"link"=>"http://i.imgur.com/abcDEF7h.gif", "width"=>100, "height"=>200, "type"=>"image/gif"}],
        ["gif"                   , "https://i.imgur.com/abcD5.mp4",          "https://api.imgur.com/3/image/abcD5/0.json",     {"link"=>"https://i.imgur.com/abcD5.gif", "width"=>100, "height"=>200, "type"=>"image/gif"}],
        ["mp4"                   , "https://i.imgur.com/abcDEF7.png",        "https://api.imgur.com/3/image/abcDEF7/0.json",   {"link"=>"https://i.imgur.com/abcDEF7.png", "width"=>100, "height"=>200, "type"=>"image/png"}],
        ["fb"                    , "https://i.imgur.com/abcDEF7.jpg?fb",     "https://api.imgur.com/3/image/abcDEF7/0.json",   {"link"=>"https://i.imgur.com/abcDEF7.jpg", "width"=>100, "height"=>200, "type"=>"image/jpeg"}],
        ["jpEg"                  , "https://i.imgur.com/abcDEF7.jpeg",       "https://api.imgur.com/3/image/abcDEF7/0.json",   {"link"=>"https://i.imgur.com/abcDEF7.jpg", "width"=>100, "height"=>200, "type"=>"image/jpeg"}],
        [nil                     , "http://m.imgur.com/abcDEF7",             "https://api.imgur.com/3/image/abcDEF7/0.json",   {"link"=>"https://i.imgur.com/abcDEF7.jpg", "width"=>100, "height"=>200, "type"=>"image/jpeg"}],
        [nil                     , "https://imgur.com/abcDEF7",              "https://api.imgur.com/3/image/abcDEF7/0.json",   {"link"=>"https://i.imgur.com/abcDEF7.mp4", "width"=>100, "height"=>200, "type"=>"video/mp4"}],
        [nil                     , "http://imgur.com/abcDEF7",               "https://api.imgur.com/3/image/abcDEF7/0.json",   {"link"=>"https://i.imgur.com/abcDEF7.jpg", "width"=>100, "height"=>200, "type"=>"image/jpeg"}],
        ["5 char photo"          , "https://imgur.com/abcD5",                "https://api.imgur.com/3/image/abcD5/0.json",     {"link"=>"https://i.imgur.com/abcD5.jpg",   "width"=>100, "height"=>200, "type"=>"image/jpeg"}],
        ["single photo album"    , "https://imgur.com/a/abcD5",              "https://api.imgur.com/3/album/abcD5/0.json",     {"images"=>["link"=>"https://i.imgur.com/abcDEF7.jpg", "width"=>100, "height"=>200, "type"=>"image/jpeg"]}],
        ["5 char https album"    , "https://imgur.com/a/abcD5",              "https://api.imgur.com/3/album/abcD5/0.json",     {"images"=>["link"=>"https://i.imgur.com/abcDEF7.jpg", "width"=>100, "height"=>200, "type"=>"image/jpeg"]*6}, 6],
        ["7 char https album"    , "https://imgur.com/a/abcDEF7",            "https://api.imgur.com/3/album/abcDEF7/0.json",   {"images"=>["link"=>"https://i.imgur.com/abcDEF7.png", "width"=>100, "height"=>200, "type"=>"image/png"]*2}, 2],
        ["album zoomable"        , "http://imgur.com/a/abcD5",               "https://api.imgur.com/3/album/abcD5/0.json",     {"images"=>["link"=>"https://i.imgur.com/abcDEF7.jpg", "width"=>100, "height"=>200, "type"=>"image/jpeg"]*49}, 49],
        ["album not zoomable"    , "http://imgur.com/a/abcD5",               "https://api.imgur.com/3/album/abcD5/0.json",     {"images"=>["link"=>"https://i.imgur.com/abcDEF7.png", "width"=>100, "height"=>200, "type"=>"image/png"]*20}, 20],
        [nil                     , "http://imgur.com/gallery/abcDEF7/new",   "https://api.imgur.com/3/gallery/abcDEF7/0.json", {"link"=>"https://i.imgur.com/abcDEF7.jpg", "width"=>100, "height"=>200, "type"=>"image/jpeg"}],
        [nil                     , "http://imgur.com/gallery/abcD5",         "https://api.imgur.com/3/gallery/abcD5/0.json",   {"images"=>["link"=>"https://i.imgur.com/abcDEF7.jpg", "width"=>100, "height"=>200, "type"=>"image/jpeg"]*7}, 7],
        ["single image gallery?" , "http://imgur.com/gallery/abcDEF7",       "https://api.imgur.com/3/gallery/abcDEF7/0.json", {"link"=>"https://i.imgur.com/abcDEF7.png", "width"=>100, "height"=>200, "type"=>"image/png"}],
        [nil                     , "http://imgur.com/gallery/abcD5/new",     "https://api.imgur.com/3/gallery/abcD5/0.json",   {"link"=>"https://i.imgur.com/abcDEF7.jpg", "width"=>100, "height"=>200, "type"=>"image/jpeg"}],
        ["gallery mp4"           , "https://imgur.com/gallery/abcDEF7",      "https://api.imgur.com/3/gallery/abcDEF7/0.json", {"link"=>"https://i.imgur.com/abcDEF7.mp4", "width"=>100, "height"=>200, "type"=>"video/mp4"}],
        ["id belongs to an image", "http://imgur.com/gallery/abcDEF7",       "https://api.imgur.com/3/gallery/abcDEF7/0.json", {status: [404, "Not Found"]}, DirectLink::ErrorNotFound],
        ["id belongs to an album", "http://imgur.com/gallery/abcD5",         "https://api.imgur.com/3/gallery/abcD5/0.json",   {status: [404, "Not Found"]}, DirectLink::ErrorNotFound],
        [nil                     , "http://imgur.com/r/wallpaper/abcDEF7",   "https://api.imgur.com/3/image/abcDEF7/0.json",   {"link"=>"https://i.imgur.com/abcDEF7.jpg?1", "width"=>100, "height"=>200, "type"=>"image/jpeg"}],
        [nil                     , "https://imgur.com/abcDEF7?third_party=1#_=_", "https://api.imgur.com/3/image/abcDEF7/0.json", {"link"=>"https://i.imgur.com/abcDEF7.jpg", "width"=>100, "height"=>200, "type"=>"image/jpeg"}],
      ].each_with_index do |t, i|
        desc, url, stub_head, stub, m = t
        it "kinds of post ##{i + 1}#{" (#{desc})" if desc}" do
          case m
          when Class
            stub_request(:head, stub_head).to_return(stub) if stub_head
            assert_raises m do
              DirectLink.imgur url
            end
          when NilClass
            stub_request(:head, stub_head) if stub_head
            stub_request(:get, stub_head).to_return body: {data: stub}.to_json if stub
            real = DirectLink.imgur url
            assert_equal 1, real.size
            assert_equal((stub["images"] ? stub["images"][0].values : stub.values), real.first)
          when Numeric
            stub_request(:head, stub_head) if stub_head
            stub_request(:get, stub_head).to_return body: {data: stub}.to_json if stub
            real = DirectLink.imgur url
            assert_equal m, real.size
            assert_equal stub["images"][0].values, real.first
          else
            fail "bug in tests"
          end
        end
      end
    end

    describe "_500px" do
      [
        ["https://500px.com/photo/123456789/morning-by",        [1200,  800, "https://drscdn.500px.org/photo/123456789/m%3D900/v2?sig=#{Array.new(64){rand(16).to_s(16)}.join}", "jpeg"]],
        ["https://500px.com/photo/1234567890/-flowers-by/",     [1819, 2500, "https://drscdn.500px.org/photo/1234567890/m%3D900/v2?sig=#{Array.new(64){rand(16).to_s(16)}.join}", "jpeg"]],
        ["https://500px.com/photo/1234567890/is%E5-by-%E7ku-/", [2048, 2048, "https://drscdn.500px.org/photo/1234567890/m%3D2048/v2?sig=#{Array.new(64){rand(16).to_s(16)}.join}", "jpeg"]]
      ].each_with_index do |(input, (w, h, u, t)), i|
        it "kinds of links" do
          id = URI(input).path[/\d+/]
          stub_request(:head, "https://api.500px.com/v1/photos?ids=#{id}")
          stub_request(:get, "https://api.500px.com/v1/photos?ids=#{id}").to_return body: {"photos"=>{id=>{"width"=>w,"height"=>h}}}.to_json
          stub_request(:head, "https://api.500px.com/v1/photos?ids=#{id}&image_size%5B%5D=#{w}")
          stub_request(:get, "https://api.500px.com/v1/photos?ids=#{id}&image_size%5B%5D=#{w}").to_return body: {"photos"=>{id=>{"images"=>[{"format"=>t,"url"=>u}]}}}.to_json
          result = DirectLink.method(:_500px).call input
          assert_equal [w, h, u, t], result, "#{input} :: #{result.inspect} != #{[w, h, u, t].inspect}"
        end
      end
    end

    describe "flickr" do
      [
        ["https://www.flickr.com/photos/tomas-/12345678901/", DirectLink::ErrorNotFound],
        ["https://www.flickr.com/photos/12345678@N07/12345678901", DirectLink::ErrorNotFound],
        ["https://www.flickr.com/photos/12345678@N00/12345678901/", [3000, 2000, "https://live.staticflickr.com/7757/12345678901_ed5178cc6a_o.jpg"]],                            # trailing slash
        ["https://www.flickr.com/photos/jacob_schmidt/12345678901/in/album-12345678901234567/", DirectLink::ErrorNotFound],                                                      # username in-album
        ["https://www.flickr.com/photos/tommygi/1234567890/in/dateposted-public/", [1600, 1062, "https://live.staticflickr.com/5249/1234567890_29fae96e38_h.jpg"]],              # username in-public
        ["https://www.flickr.com/photos/123456789@N02/12345678901/in/album-12345678901234567/", DirectLink::ErrorNotFound],
        ["https://www.flickr.com/photos/123456789@N03/12345678901/in/dateposted-public/", [4621, 3081, "https://live.staticflickr.com/3796/12345678901_f751b35aeb_o.jpg"]],      # userid   in-public
        ["https://www.flickr.com/photos/frank3/1234567890/in/photolist#{"-6KVb92"*50}", [4096, 2723, "https://live.staticflickr.com/2499/1234567890_dfa75a41cc_4k.jpg"]],
        ["https://www.flickr.com/photos/patricksloan/12345678901/sizes/l", [2048, 491, "https://live.staticflickr.com/5572/12345678900_fec4783d79_k.jpg"]],
        ["https://flic.kr/p/abcDEF", [5120, 3413, "https://live.staticflickr.com/507/12345678901_1bd49c5ebd_5k.jpg"]],
      ].each_with_index do |(input, expectation), i|
        it "kinds of links" do
          stub_request(:head, /\Ahttps:\/\/api\.flickr\.com\/services\/rest\/\?api_key=#{ENV["FLICKR_API_KEY"]}&format=json&method=flickr\.photos\.getSizes&nojsoncallback=1&photo_id=[\da-zA-Z]+\z/)
          if expectation.is_a? Class
            stub_request(:get, /\Ahttps:\/\/api\.flickr\.com\/services\/rest\/\?api_key=#{ENV["FLICKR_API_KEY"]}&format=json&method=flickr\.photos\.getSizes&nojsoncallback=1&photo_id=[\da-zA-Z]+\z/).to_return body: {"stat"=>"fail", "code"=>1, "message"=>"Photo not found"}.to_json
            assert_raises expectation, input do
              DirectLink.method(:flickr).call input
            end
          else
            w, h, u = expectation
            stub_request(:get, /\Ahttps:\/\/api\.flickr\.com\/services\/rest\/\?api_key=#{ENV["FLICKR_API_KEY"]}&format=json&method=flickr\.photos\.getSizes&nojsoncallback=1&photo_id=[\da-zA-Z]+\z/).to_return body: {"stat"=>"ok", "sizes"=>{ "size"=>[
              {"width"=>w/2, "height"=>h  , "source"=>u*2},
              {"width"=>w  , "height"=>h  , "source"=>u  },
              {"width"=>w  , "height"=>h/2, "source"=>u*2},
            ] } }.to_json
            result = DirectLink.method(:flickr).call input
            assert_equal expectation, result, "#{input} :: #{result.inspect} != #{expectation.inspect}"
          end
        end
      end
    end

    describe "wiki" do
      [
        ["https://en.wikipedia.org/wiki/Prostitution_by_country#/media/File:Prostitution_laws_of_the_world.PNG", "https://upload.wikimedia.org/wikipedia/commons/e/e8/Prostitution_laws_of_the_world.PNG"],
        ["https://en.wikipedia.org/wiki/Third_Party_System#/media/File:United_States_presidential_election_results,_1876-1892.svg", DirectLink::ErrorAssert],
        ["http://commons.wikimedia.org/wiki/File:Eduard_Bohlen_anagoria.jpg", "https://upload.wikimedia.org/wikipedia/commons/0/0d/Eduard_Bohlen_anagoria.jpg"],
        ["https://en.wikipedia.org/wiki/Spanish_Civil_War#/media/File:Alfonso_XIIIdeEspa%C3%B1a.jpg", "https://upload.wikimedia.org/wikipedia/commons/f/fb/Alfonso_XIIIdeEspa%C3%B1a.jpg"],   # escaped input URI
        ["https://en.wikipedia.org/wiki/File:Tyson_Lewis.jpg", "https://upload.wikimedia.org/wikipedia/en/c/cd/Tyson_Lewis.jpg"],  # exists only in en.wiki, not in commons
      ].each_with_index do |(input, expectation), i|
        it "kinds of links" do
          url = URI(input).tap{ |_| _.fragment = nil }.to_s
          stub_request(:head, url)
          stub_request(:head, "https://#{URI(input).hostname}/w/api.php?action=query&format=json&iiprop=url&prop=imageinfo&titles=#{input[/(File:.+)/]}")
          if expectation.is_a? Class
            stub_request(:get, "https://en.wikipedia.org/w/api.php?action=query&format=json&iiprop=url&prop=imageinfo&titles=#{input[/(File:.+)/]}").to_return body: {
              "query"=>{"pages"=>{"-1"=>{}}}
            }.to_json
            assert_raises expectation, input do
              DirectLink.wiki input
            end
          else
            stub_request(:get, "https://#{URI(input).hostname}/w/api.php?action=query&format=json&iiprop=url&prop=imageinfo&titles=#{input[/(File:.+)/]}").to_return body: {
              "query"=>{"pages"=>{"-1"=>{"imageinfo"=>[{"url"=>expectation}]}}}
            }.to_json
            result = DirectLink.wiki input
            assert_equal expectation, result, "#{input} :: #{result.inspect} != #{expectation.inspect}"
          end
        end
      end
    end

    describe "reddit" do
      [
        ["https://i.redd.it/abcde6k7r5xz.jpg", [true, "https://i.redd.it/abcde6k7r5xz.jpg"]],
        ["https://www.reddit.com/r/cacography/comments/abcde6/c/", [true, "http://i.imgur.com/abcde6Z.jpg"], false, "abcde6"],
        ["http://redd.it/abcde6", [true, "http://i.imgur.com/abcde6Z.jpg"], false, "abcde6"],                    # TODO maybe check that it calls #imgur recursively
        ["http://redd.it/abcde6", [true, "https://i.redd.it/abcde66ehrg11.jpg"], false, "abcde6"],
        ["https://reddit.com/abcde6", [true, "https://i.ytimg.com/vi/abcde6RbIeU/hqdefault.jpg"],
          false, "abcde6",
          {"type"=>"youtube.com","oembed"=>{"thumbnail_url"=>"https://i.ytimg.com/vi/abcde6RbIeU/hqdefault.jpg"}},
          nil,
          "http://www.youtube.com/watch?v=abcde6RbIeU&amp;feature=g-vrec",
        ],
        ["https://www.reddit.com/r/hangers/comments/abcde6/tara_radovic/", [true, "https://i.imgur.com/abcDE6u.jpg"],
          false, "abcde6",
          nil,
          "t3_abcde7",
        ],   # "crossport" from Imgur
        ["https://www.reddit.com/gallery/abcde6",
          [true, [
            ["image/jpg", 1440, 1440, "https://preview.redd.it/abcde6j6vee51.jpg?width=1440&format=pjpg&auto=webp&s=b79952f8364bb98692d978944347f19e28774d1b"],
            ["image/jpg", 2441, 2441, "https://preview.redd.it/abcde6j6vee51.jpg?width=2441&format=pjpg&auto=webp&s=455e669356550351e6b8768d8009de616c11142a"],
          ] ],
          false, "abcde6",
          nil,
          nil,
          "https://www.reddit.com/gallery/abcde6",
          {
            "x31msdjabcde6"=>{
              "status"=>"valid", "m"=>"image/jpg", "s"=>{
                "y"=>1440,
                "x"=>1440,
                "u"=>"https://preview.redd.it/abcde6j6vee51.jpg?width=1440&amp;format=pjpg&amp;auto=webp&amp;s=b79952f8364bb98692d978944347f19e28774d1b",
              },
            },
            "mwkzq6jabcde6"=>{
              "status"=>"valid", "m"=>"image/jpg", "s"=>{
                "y"=>2441,
                "x"=>2441,
                "u"=>"https://preview.redd.it/abcde6j6vee51.jpg?width=2441&amp;format=pjpg&amp;auto=webp&amp;s=455e669356550351e6b8768d8009de616c11142a",
              },
            },
          },
        ],
        ["https://www.reddit.com/abcde6",
          [true, [
            ["image/jpg", 1440, 1440, "https://preview.redd.it/abcde6j6vee51.jpg?width=1440&format=pjpg&auto=webp&s=b79952f8364bb98692d978944347f19e28774d1b"],
            ["image/jpg", 2441, 2441, "https://preview.redd.it/abcde6j6vee51.jpg?width=2441&format=pjpg&auto=webp&s=455e669356550351e6b8768d8009de616c11142a"],
          ] ],
          false, "abcde6",
          nil,
          nil,
          "https://www.reddit.com/gallery/abcde6",
          {
            "x31msdjabcde6"=>{
              "status"=>"valid", "m"=>"image/jpg", "s"=>{
                "y"=>1440,
                "x"=>1440,
                "u"=>"https://preview.redd.it/abcde6j6vee51.jpg?width=1440&amp;format=pjpg&amp;auto=webp&amp;s=b79952f8364bb98692d978944347f19e28774d1b",
              },
            },
            "mwkzq6jabcde6"=>{
              "status"=>"valid", "m"=>"image/jpg", "s"=>{
                "y"=>2441,
                "x"=>2441,
                "u"=>"https://preview.redd.it/abcde6j6vee51.jpg?width=2441&amp;format=pjpg&amp;auto=webp&amp;s=455e669356550351e6b8768d8009de616c11142a",
              },
            },
          },
        ],
        ["https://www.reddit.com/gallery/abcde6", [true, "https://www.reddit.com/gallery/abcde6"], false, "abcde6"],   # deleted gallery
        ["https://www.reddit.com/abcde6", [true, "https://www.reddit.com/r/Firewatch/comments/abcde7/new_wallpaper/"],
          false, "abcde6",
          nil,
          "t3_abcde7",
          "/r/Firewatch/comments/abcde7/new_wallpaper/",
        ],   # deleted gallery
        ["https://www.reddit.com/abcde6",
          [true, [
            ["image/jpg", 500, 500, "https://preview.redd.it/abcde6eexo461.jpg?width=500&format=pjpg&auto=webp&s=df211fe0699e3970681ffe493ed1af79725857e8"],
            ["image/jpg", 720, 446, "https://preview.redd.it/abcde6hexo461.jpg?width=720&format=pjpg&auto=webp&s=5e34ab0e6d54c0acfdb47f1daaf283087c5ad6a6"],
            ["image/jpg", 713, 588, "https://preview.redd.it/abcde6lexo461.jpg?width=713&format=pjpg&auto=webp&s=969dfb52bedd6f0055249aa8b7454b23adaa946e"],
          ] ],
          false, "abcde6",
          nil,
          nil,
          "https://www.reddit.com/gallery/abcde6",
          {
            "71t8ljeabcde6"=>{
              "status"=>"valid", "m"=>"image/jpg", "s"=>{
                "y"=>500,
                "x"=>500,
                "u"=>"https://preview.redd.it/abcde6eexo461.jpg?width=500&amp;format=pjpg&amp;auto=webp&amp;s=df211fe0699e3970681ffe493ed1af79725857e8",
              },
            },
            "bfmjbtjabcde6"=>{"status"=>"failed"},
            "c11nt7habcde6"=>{
              "status"=>"valid", "m"=>"image/jpg", "s"=>{
                "y"=>446,
                "x"=>720,
                "u"=>"https://preview.redd.it/abcde6hexo461.jpg?width=720&amp;format=pjpg&amp;auto=webp&amp;s=5e34ab0e6d54c0acfdb47f1daaf283087c5ad6a6",
              },
            },
            "67mqvllabcde6"=>{
              "status"=>"valid", "m"=>"image/jpg", "s"=>{
                "y"=>588,
                "x"=>713,
                "u"=>"https://preview.redd.it/abcde6lexo461.jpg?width=713&amp;format=pjpg&amp;auto=webp&amp;s=969dfb52bedd6f0055249aa8b7454b23adaa946e"
              },
            },
          },
        ],   # failed media
        ["https://www.reddit.com/r/CatsStandingUp/duplicates/abcde6/cat/",
          [true, "https://v.redd.it/abcde6fb6w721/DASH_2_4_M?source=fallback"],
          false, "abcde6",
          {"reddit_video"=>{"fallback_url"=>"https://v.redd.it/abcde6fb6w721/DASH_2_4_M?source=fallback"}},
          nil,
          "https://v.redd.it/abcde6fb6w721",
        ],
      ].each_with_index do |(input, expectation, is_self, id, media, crosspost_parent, url, media_metadata), i|
        it "kinds of links" do
          unless is_self.nil?
            fail "bug in test: no id" unless id
            stub_request(:post, "https://www.reddit.com/api/v1/access_token").to_return body: {"access_token"=>"123456789012-abcDE6CFsglE63e5F1v8ThrVa9HThg"}.to_json
            stub_request(:get, "https://oauth.reddit.com/by_id/t3_#{id}?api_type=json").to_return body: {
              "data"=>{"children"=>[{"data"=>{
                "is_self"=>is_self,
                "media"=>media,
                "crosspost_parent"=>crosspost_parent,
                "url"=>(url||expectation[1]),
                "media_metadata"=>media_metadata,
                # "permalink"=>"/r/cacography/comments/32tq0i/c/",
                # "selftext"=>"",
              }}]}
            }.to_json
          end
          result = DirectLink.reddit input
          assert_equal expectation, result, "#{input} :: #{result.inspect} != #{expectation.inspect}"
        end
      end
    end

    describe "vk" do
      [
        ["https://vk.com/wall-123456091_7806", [960, 1280, "https://userapi.com/impf/c123456/v123456900/a72f1/7OZ8ux9Wcwo.jpg"], "wall", [
          [97, 130, "https://sun9-3.userapi.com/impf/c123456/v123456900/a72f1/7OZ8ux9Wcwo.jpg?size=98x130&quality=96&sign=1f2bdc7b856b2a8f60297e3ac2c58689&c_uniq_tag=ggVFjBTdFDFuIz7Ee5o48mEP3fWLixCvjuPmehhyaTI&type=album"],
          [960, 1280, "https://sun9-3.userapi.com/impf/c123456/v123456900/a72f1/7OZ8ux9Wcwo.jpg?size=960x1280&quality=96&proxy=1&sign=985328651fa11a0daef2c2a324f2de09&c_uniq_tag=vKCnEFEDol5QYM0qPrYAkbDwzYo6U_jo0SOR8iQO7HA&type=album"],
        ] ],
        ["https://vk.com/wall-123456611_454?z=photo-123456611_457239340%2Fwall-123456611_454", [1280, 960, "https://userapi.com/impf/c123456/v123456578/1a62f6/VB4SdR1O6Tg.jpg"], "photos", [
          [130, 97, "https://sun9-59.userapi.com/impf/c123456/v123456578/1a62f6/VB4SdR1O6Tg.jpg?size=130x98&quality=96&sign=1e56a7310fd780cd48bed7304a369b1c&c_uniq_tag=xJlpXkJvi0P9WQhcM5acgLHqSUzXK3FGahuZHHncZQY&type=album"],
          [1280, 960, "https://sun9-59.userapi.com/impf/c123456/v123456578/1a62f6/VB4SdR1O6Tg.jpg?size=1280x960&quality=96&proxy=1&sign=f5825d997937393a5c0a95c6775dce19&c_uniq_tag=2ulEOYXMOAN-KJm7HPNZYNcScyikyHdIsRmeqM8i16w&type=album"],
        ] ],
        ["https://vk.com/wall-123456091_7946?z=photo-123456091_457243312%2Falbum-123456091_00%2Frev", [1280, 875, "https://userapi.com/impf/c123456/v123456134/1b6b36/0IsDFb-Hda4.jpg"], "photos", [
          [130, 89, "https://sun9-20.userapi.com/impf/c123456/v123456134/1b6b36/0IsDFb-Hda4.jpg?size=130x89&quality=96&sign=20f98d85da83704a93641c258dd9fb98&c_uniq_tag=PcNYWJFing2At2LiJVOYQOTUd_MbMLxiyPybwnyzaN4&type=album"],
          [1280, 875, "https://sun9-20.userapi.com/impf/c123456/v123456134/1b6b36/0IsDFb-Hda4.jpg?size=1280x875&quality=96&proxy=1&sign=9b1e295c741c53b9485f4156da36ecde&c_uniq_tag=o7eFSi5F74SmkTirdrIS19nh8CEG32Od6yPvX9IPXds&type=album"],
        ] ],
        ["https://vk.com/id12345627?z=photo12345627_456241143%2Falbum12345627_0", [1920, 1440, "https://userapi.com/impf/c123456/v123456944/167836/bP9z41BybhI.jpg"], "photos", [
          [130, 97, "https://sun9-9.userapi.com/impf/c123456/v123456944/167836/bP9z41BybhI.jpg?size=130x98&quality=96&sign=5a7785886e75cde41f7ddc190775c941&c_uniq_tag=uJX7tU35qumnZFlAUe-EhyVVT1FDBoHmp_8Z-dFAH_I&type=album"],
          [1920, 1440, "https://sun9-9.userapi.com/impf/c123456/v123456944/167836/bP9z41BybhI.jpg?size=1920x1440&quality=96&proxy=1&sign=56acc1844d38b491c1b2e4dbedd76ba4&c_uniq_tag=06VziJvbo7gkdo5t0AUEQRs6EX8UrmiT2XkfGRmfRz8&type=album"],
        ] ],
        ["https://vk.com/id12345627?z=photo12345627_456241143", [1920, 1440, "https://userapi.com/impf/c123456/v123456944/167836/bP9z41BybhI.jpg"], "photos", [
          [130, 97, "https://sun9-9.userapi.com/impf/c123456/v123456944/167836/bP9z41BybhI.jpg?size=130x98&quality=96&sign=5a7785886e75cde41f7ddc190775c941&c_uniq_tag=uJX7tU35qumnZFlAUe-EhyVVT1FDBoHmp_8Z-dFAH_I&type=album"],
          [1920, 1440, "https://sun9-9.userapi.com/impf/c123456/v123456944/167836/bP9z41BybhI.jpg?size=1920x1440&quality=96&proxy=1&sign=56acc1844d38b491c1b2e4dbedd76ba4&c_uniq_tag=06VziJvbo7gkdo5t0AUEQRs6EX8UrmiT2XkfGRmfRz8&type=album"],
        ] ],
        ["https://vk.com/photo1_123187843?all=1", [2560, 1913, "https://userapi.com/impf/c123/v123001/6/53_VwoACy4I.jpg"], "photos", [
          [130, 98, "https://sun1-23.userapi.com/impf/c123/v123001/6/53_VwoACy4I.jpg?size=130x97&quality=96&sign=f8f5b706de9bf4cba377c4192ca0faeb&c_uniq_tag=Hq3mDN7NbJvgRd82cKsQpJ45Tze8deKbUX4FZDwVZGQ&type=album"],
          [2560, 1913, "https://sun1-23.userapi.com/impf/c123/v123001/6/53_VwoACy4I.jpg?size=2560x1913&quality=96&proxy=1&sign=c55f340348a35dd86542875a57ad8537&c_uniq_tag=yANq6f3QAVxu7M1xuy6fMu1JgkYOPqB1jBV4bQVjc0Y&type=album"],
        ] ],
        ["https://vk.com/photo123456340_456243948?rev=1", [1583, 1080, "https://userapi.com/impf/c123456/v123456479/321be/9rZaJ2QTdz4.jpg"], "photos", [
          [130, 89, "https://sun9-21.userapi.com/impf/c123456/v123456479/321be/9rZaJ2QTdz4.jpg?size=130x89&quality=96&sign=4095eaa6d55dbb6af3a6d3baed593ecb&c_uniq_tag=9comrJGukZcMLlCDrmQMWhFtne217kVaZcafgoQmCVM&type=album"],
          [1583, 1080, "https://sun9-21.userapi.com/impf/c123456/v123456479/321be/9rZaJ2QTdz4.jpg?size=1583x1080&quality=96&proxy=1&sign=27a9d92fcbd2cf748531a89278281cc3&c_uniq_tag=iwiLvdT52wwR8avHhjDUwPUozsvMpVyuFHHACavY2zA&type=album"],
        ] ],
        ["https://vk.com/photo-123456973_456242404", [1486, 1000, "https://userapi.com/impf/c123456/v123456877/8578e/m6AJWiskiKE.jpg"], "photos", [
          [130, 87, "https://sun9-51.userapi.com/impf/c123456/v123456877/8578e/m6AJWiskiKE.jpg?size=130x87&quality=96&sign=c89c47cebc77fd0063dbe4891245aebe&c_uniq_tag=pSxKInGItqdMMW_83z9SXDzIi74Zl9UJ-P-snVmzHHY&type=album"],
          [1486, 1000, "https://sun9-51.userapi.com/impf/c123456/v123456877/8578e/m6AJWiskiKE.jpg?size=1486x1000&quality=96&proxy=1&sign=f67bdef805a49775776ba9fe3ddddfdd&c_uniq_tag=2IwG6BAja36QQl3mDsUcWS6PC7ozt6TSExLsfRXRyzA&type=album"],
        ] ],
        ["https://vk.com/feed?section=likes&z=photo-123456754_456261460%2Fliked1234566", [1024, 1335, "https://userapi.com/impf/c123456/v123456353/895b6/izQJresLdf0.jpg"], "photos", [
          [100, 130, "https://sun9-55.userapi.com/impf/c123456/v123456353/895b6/izQJresLdf0.jpg?size=100x130&quality=96&sign=56c2f6f2e772c5cac6e891d62c6c563e&c_uniq_tag=HHJ8PsYFgnwmuq9OfND51luLXJve81QbpWvudWXv5aw&type=album"],
          [1024, 1335, "https://sun9-55.userapi.com/impf/c123456/v123456353/895b6/izQJresLdf0.jpg?size=1024x1335&quality=96&proxy=1&sign=b66a4c70eeb4083a05907e36d18cc481&c_uniq_tag=42fraqliOifFUG1CvgahG1lg1txVMF5hbSVlAUkLwf8&type=album"],
        ] ],
        ["https://vk.com/likizimy?z=photo-12345651_456239941%2Fwall-12345651_1908", [1179, 1731, "https://userapi.com/impf/c123456/v123456571/60f7b/ryCPJIMyMkI.jpg"], "photos", [
          [89, 130, "https://sun9-37.userapi.com/impf/c123456/v123456571/60f7b/ryCPJIMyMkI.jpg?size=89x130&quality=96&sign=3ae95211e73168c7b66e12daa854f922&c_uniq_tag=uaDVTYCfixIN4JKSGzgNSTsjiuOUi0658_CgoIF-mqc&type=album"],
          [1179, 1731, "https://sun9-37.userapi.com/impf/c123456/v123456571/60f7b/ryCPJIMyMkI.jpg?size=1179x1731&quality=96&proxy=1&sign=7930a6d1b4a88ce1fa4954fc6643d3e1&c_uniq_tag=rTxHctkqrP4SQsbcECYGDCVt03A43cLYRN8eTnOFtD0&type=album"],
        ] ],
        ["https://vk.com/e_rod?z=photo123456340_457247118%2Fphotos123456340", [1728, 2160, "https://userapi.com/impf/c123456/v123456596/c7714/oImGe4o1ZJI.jpg"], "photos", [
          [104, 130, "https://sun9-53.userapi.com/impf/c123456/v123456596/c7714/oImGe4o1ZJI.jpg?size=104x130&quality=96&sign=6ad356e84dcd6bbf2069d9b869a7bdb1&c_uniq_tag=8KN44nSlDjD-FMDiRhHqk6udwiqZfn5n1qqPNFwu_nI&type=album"],
          [1728, 2160, "https://sun9-53.userapi.com/impf/c123456/v123456596/c7714/oImGe4o1ZJI.jpg?size=1728x2160&quality=96&proxy=1&sign=c7961913ff3efd5064f2ed6c394288f2&c_uniq_tag=CA61KgCRsRXbHm4VJEYYskjpjpSiTHI7UPV4FsCPRmI&type=album"],
        ] ],
      ].each_with_index do |(input, expectation, mtd, stub), i|
        it "kinds of links" do
          stub = {sizes: stub.map{ |w,h,u| {width: w, height: h, url: u} }}
          stub_request(:post, "https://api.vk.com/method/#{mtd}.getById").to_return body: {response: [
            mtd == "photos" ? stub : {attachments: [{type: :photo, photo: stub}]}
          ] }.to_json
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

    describe "google" do
      method = :google
      [
        "https://lh3.googleusercontent.com/-NVJgqmI_2Is/WqMM2OMYg-I/AAAAAAAALrk/5-p3JL3iZt0Ho9dOf_abcDE6zqwr3Wp0ACJoC/w424-h318-n/001",
        "//lh3.googleusercontent.com/proxy/DZtTi5KL7PqiBwJc8weNGLk_Wi2UTaQH0AC_abcDE6iu0AbwyI2ywOk2XgdAjL7ceg=w530-h354-n",
        "//1.bp.blogspot.com/-rYk_u-qROQc/WngolJ8M0LI/AAAAAAAAD-w/woivnaIVzasBPG5C2T1t-VrWKRd_abcDE6LcBGAs/w530-h278-p/i-469.jpg",
        "https://2.bp.blogspot.com/-rb2PXLGZy0s/W2nQe3mXOSI/AAAAAAAARhQ/P8gV-abcDE62xxpTJNcYVxu3XDTUaugxQCLcBGAs/s640/beach-bora-bora-clouds-753626.jpg",
        "http://4.bp.blogspot.com/-poH-QXn7YGg/U-3ZTDkeF_I/AAAAAAAAISE/mabcDE6-v-g/w72-h72-p-k-no-nu/Top-24-Inspired-181.jpg",
        "https://lh5.googleusercontent.com/FcYUQBKLXWtFLEvbQduvu7FHUm2f7U_MVdMBVnNbpwfzKHIU-xABkudxw-abcDE60jFYRHedh7Is5Dg6qlgIQF1iSndlWjiKCTTsUo1w=s1080",
      ].each do |input|
        it "DirectLink() choses a method '#{method}' according to a domain" do
          DirectLink.stub method, ->(link, timeout = nil){
            assert_equal input, link
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

    {
      imgur: [
        [%w{ https://imgur.com/abcD5 https://imgur.com/abcD5 }, [
          %w{ https://imgur.com/abcD5 },
        ] ],
        [%w{ https://i.imgur.com/abcD5 https://imgur.com/abcD5 }, [
          [*%w{ https://i.imgur.com/abcD5 https://imgur.com/abcD5 }, [302, "Moved Temporarily"]],
          %w{ https://imgur.com/abcD5 },
        ] ],
        [%w{ https://m.imgur.com/abcD5 https://imgur.com/abcD5 }, [
          %w{ https://m.imgur.com/abcD5 https://imgur.com/abcD5 },
          %w{ https://imgur.com/abcD5 },
        ] ],
        [%w{ https://www.imgur.com/abcD5 https://imgur.com/abcD5 }, [
          [*%w{ https://www.imgur.com/abcD5 https://imgur.com/abcD5 }, [301, "Moved Permanently"]],
          %w{ https://imgur.com/abcD5 },
        ] ],
        [%w{ https://goo.gl/abcDE6 https://i.imgur.com/abcDEFY.png }, [
          %w{ https://goo.gl/abcDE6 https://i.imgur.com/abcDEFY.png },
          %w{ https://i.imgur.com/abcDEFY.png },
        ] ],
      ],
      _500px: [
        [%w{ https://500px.com/photo/123456789/milky-way https://500px.com/photo/123456789/milky-way }, [
          %w{ https://500px.com/photo/123456789/milky-way },
        ] ],
      ],
      flickr: [
        ["https://www.flickr.com/photos/12345678@N07/12345678901/in/dateposted-public/", [
          ["https://www.flickr.com/photos/12345678@N07/12345678901/in/dateposted-public/"],
        ] ],
        [["https://flic.kr/p/abcDEF", "https://www.flickr.com/photos/lopez/12345678901/"], [
          ["https://flic.kr/p/abcDEF", "https://www.flickr.com/photo.gne?short=abcDEF"],
          ["https://www.flickr.com/photo.gne?short=abcDEF", "/photo.gne?rb=1&short=abcDEF"],
          ["https://www.flickr.com/photo.gne?rb=1&short=abcDEF", "/photos/lopez/12345678901/"],
          ["https://www.flickr.com/photos/lopez/12345678901/"],
        ] ],
      ],
      wiki: [
        ["https://en.wikipedia.org/wiki/Third_Party_System#/media/File:United_States_presidential_election_results,_1876-1892.svg", [
          %w{ https://en.wikipedia.org/wiki/Third_Party_System },
        ] ],
        [%w{ http://commons.wikimedia.org/wiki/File:Eduard_Bohlen_anagoria.jpg https://commons.wikimedia.org/wiki/File:Eduard_Bohlen_anagoria.jpg }, [
          %w{ http://commons.wikimedia.org/wiki/File:Eduard_Bohlen_anagoria.jpg https://commons.wikimedia.org/wiki/File:Eduard_Bohlen_anagoria.jpg },
          %w{ https://commons.wikimedia.org/wiki/File:Eduard_Bohlen_anagoria.jpg }
        ] ],
      ],
      reddit: [
        [%w{ https://www.reddit.com/r/abcdef/comments/abcde6/c/ }, [
          %w{ https://www.reddit.com/r/abcdef/comments/abcde6/c/ },
        ] ],
        [%w{ http://redd.it/abcde6 https://www.reddit.com/comments/abcde6 }, [
          [*%w{ http://redd.it/abcde6 https://redd.it/abcde6 }, [301, "Moved Permanently"]],
          [*%w{ https://redd.it/abcde6 https://www.reddit.com/comments/abcde6 }, [302, "Temporarily Moved"]],
          %w{ https://www.reddit.com/comments/abcde6 },
        ] ],
        [%w{ https://reddit.com/123456 https://www.reddit.com/r/funny/comments/123456/im_thinking/ }, [
          [*%w{ https://reddit.com/123456 https://www.reddit.com/123456 }, [301, "Moved Permanently"]],
          [*%w{ https://www.reddit.com/123456 https://www.reddit.com/r/funny/comments/123456/im_thinking/ }, [301, "Moved Permanently"]],
          %w{ https://www.reddit.com/r/funny/comments/123456/im_thinking/ },
        ] ],
        [%w{ https://www.reddit.com/r/abcDEF/comments/abcde6/beard_trimmer/ }, [
          %w{ https://www.reddit.com/r/abcDEF/comments/abcde6/beard_trimmer/ }
        ] ], # NSFW causes redirect to /over_18? if the special cookie not provided # TODO: improve this test
      ],
      vk: [
        ["https://vk.com/id12345678?z=photo12345678_456241143", [
          ["https://vk.com/id12345678?z=photo12345678_456241143", nil, [418, ""]],
        ] ],
      ],
    }.each do |method, tests|
      describe "DirectLink() choses a method '#{method}' according to a domain" do
        tests.each_with_index do |((input, expected), stub), i|
          it "##{i + 1}" do
            DirectLink.stub method, ->(link, timeout = nil){
              assert_equal (expected || input), link
              throw :_
            } do
              (stub || []).each do |u, o, code|
                if o
                  stub_request(:head, u).to_return status: (code || [302, "Found"]), headers: {location: o}
                else
                  if code
                    stub_request(:head, u).to_return status: code
                  else
                    stub_request(:head, u)
                  end
                end
              end
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
    it "retries limited amount of times on error JSON::ParserError" do
      # TODO: the same but with the error expected to be gone after tries
      stub_request(:post, "https://www.reddit.com/api/v1/access_token").to_return body: '{"access_token": "123456789000-17BDFFGGJJKNPVXZlt-2ACKQZfoswz", "token_type": "bearer", "expires_in": 3600, "scope": "*"}'
      stub_request(:get, "https://oauth.reddit.com/by_id/t3_abcde6?api_type=json").to_return body: "invalid JSON"
      tries = 0
      m = JSON.method :load
      e = assert_raises DirectLink::ErrorBadLink do
        JSON.stub :load, ->_{ tries += 1; m.call _ } do
          DirectLink.reddit "https://www.reddit.com/r/gifs/comments/abcde6/", 2.5
        end
      end
      assert_instance_of JSON::ParserError, e.cause if Exception.instance_methods.include? :cause  # Ruby 2.1
      assert (3 <= tries)
      assert (tries <= 4)
    end
    it "Reddit correctly parses out id when no token provided" do
      stub_request(:head, "https://www.reddit.com/r/gifs/comments/9ftc8f/")
      m = NetHTTPUtils.method :request_data
      NetHTTPUtils.stub :request_data, lambda{ |u, *_|
        throw :_ if u == "https://www.reddit.com/9ftc8f.json"
        m.call u, *_
      } do
        t = ENV.delete "REDDIT_SECRETS"
        begin
          catch :_ do
            DirectLink "https://www.reddit.com/r/gifs/comments/9ftc8f/"
            fail
          end
        ensure
          ENV["REDDIT_SECRETS"] = t
        end
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

  end

  describe "DirectLink()" do

    # thanks to gem addressable
    it "does not throw URI::InvalidURIError if there are brackets" do
      stub_request(:head, "https://www.flickr.com/photos/nakilon/12345678900/%2520%5B2048x1152%5D").to_return status: [404, "Not Found"]
      assert_equal 404, (
        assert_raises NetHTTPUtils::Error do
          DirectLink "https://www.flickr.com/photos/nakilon/12345678900/%20[2048x1152]"
        end.code
      )
    end

    it "throws ErrorNotFound when Reddit gallery is removed" do
      stub_request(:head, "https://www.reddit.com/gallery/abcde6")
      stub_request(:post, "https://www.reddit.com/api/v1/access_token").to_return body: {"access_token"=>"123456789012-abcde6cOO5V20ZD6J8WC6l36gMYRXQ"}.to_json
      stub_request(:get, "https://oauth.reddit.com/by_id/t3_abcde6?api_type=json").to_return body: {
        "data"=>{
          "children"=>[{
            "data"=>{
              "selftext"=>"[удалено]",
              "media_metadata"=>nil,
              "is_self"=>false,
              "permalink"=>"/r/woahdude/comments/abcde6/crystal_light/",
              "url"=>"https://www.reddit.com/gallery/abcde6",
              "media"=>nil
            }
          }]
        }
      }.to_json
      assert_raises DirectLink::ErrorNotFound do
        DirectLink "https://www.reddit.com/gallery/abcde6"
      end
    end

    it "follows Reddit crosspost" do
      stub_request(:head, "https://www.reddit.com/abcde6").to_return status: [301, "Moved Permanently"], headers: {location: "https://www.reddit.com/r/wallpapers/comments/abcde6/new_wallpaper/"}
      stub_request(:head, "https://www.reddit.com/r/wallpapers/comments/abcde6/new_wallpaper/")
      stub_request(:post, "https://www.reddit.com/api/v1/access_token").to_return body: {"access_token"=>"123456789012-abcde6WGKuIupoi5M3NtPVdI7bk1jg"}.to_json
      stub_request(:get, "https://oauth.reddit.com/by_id/t3_abcde6?api_type=json").to_return body: {
        "data"=>{
          "children"=>[{
            "data"=>{
              "selftext"=>"",
              "is_self"=>false,
              "crosspost_parent"=>"t3_abcde7",
              "permalink"=>"/r/wallpapers/comments/abcde6/new_wallpaper/",
              "url"=>"/r/Firewatch/comments/abcde7/new_wallpaper/",
              "media"=>nil,
            }
          }]
        }
      }.to_json
      stub_request(:head, "https://www.reddit.com/r/Firewatch/comments/abcde7/new_wallpaper/")
      stub_request(:get, "https://oauth.reddit.com/by_id/t3_abcde7?api_type=json").to_return body: {
        "data"=>{
          "children"=>[{
            "data"=>{
              "selftext"=>"I",
              "media_metadata"=>{
                "abcde62zhek51"=>{
                  "status"=>"valid",
                  "m"=>"image/png",
                  "s"=>{"y"=>1920, "x"=>4920, "u"=>"asd"},
                },
                "abcde72zhek51"=>{
                  "status"=>"valid",
                  "m"=>"image/png",
                  "s"=>{"y"=>1920, "x"=>4920, "u"=>"asd"},
                }
              },
              "is_self"=>true,
              "media"=>nil,
              "permalink"=>"/r/Firewatch/comments/abcde7/new_wallpaper/",
              "url"=>"https://www.reddit.com/r/Firewatch/comments/abcde7/new_wallpaper/",
            }
          }],
        }
      }.to_json
      assert_equal %w{ image/png image/png }, DirectLink("https://www.reddit.com/abcde6").map(&:type)
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
        [:google, "//lh3.googleusercontent.com/proxy/578BDGJKLLNPTZceiikqtww_Wi2UTaQH0AC_h2kuURiu0AbwyI2ywOk2XgdAjL7ceg=w530-h354-n"],
        [:imgur, "http://imgur.com/ABCDEFG"],
        [:flickr, "https://www.flickr.com/photos/12345678@N00/00013355778/"],
        [:_500px, "https://500px.com/photo/123456789/milky-way"],
        [:wiki, "http://commons.wikimedia.org/wiki/File:Eduard_Bohlen_anagoria.jpg"],
        [:reddit, "https://www.reddit.com/123456"],
        [:vk, "https://vk.com/"],
      ].each do |method, link|
        it "can otherwise raise DirectLink::ErrorBadLink #{method}" do
          stub_request(:head, link)
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
        ["http://www.cute.org/wp-content/uploads/2010/10/Niagara.jpg", SocketError, /nodename nor servname provided, or not known|Name or service not known|getaddrinfo: Name does not resolve/, 0],
      ].each_with_index do |(input, expectation, message_string_or_regex, max_redirect_resolving_retry_delay), i|
        it "##{i + 1}" do
          if expectation.is_a? Class
            # TODO: move the stub to the array above
            stub_request(:head, input).to_raise expectation.new("Failed to open TCP connection to www.cute.org:80 (getaddrinfo: nodename nor servname provided, or not known)")
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
        [
          ["http://example.com", FastImage::UnknownImageType],
          [
            [:get, "http://example.com", {body: "<!doctype html><html><head><title>Example Domain</title><meta charset='utf-8'/></head><body><div><h1>Example Domain</h1><p>Lorem ipsum.</p></div></body></html>"}],
          ],
        ],
        [
          ["http://imgur.com/QWERTYU", FastImage::UnknownImageType, true],
          [
            [:get, "http://imgur.com/QWERTYU", {status: [301, "Moved Permanently"], headers: {location: "https://imgur.com/QWERTYU"}}],
            [:get, "https://imgur.com/QWERTYU", {body: "<html><body></body></html>"}],
          ],
        ],
        [
          ["http://imgur.com/QWERTYU", "https://i.imgur.com/QWERTYU.jpeg?fb"],  # .at_css("meta[@property='og:image']")
          [
            [:head, "http://imgur.com/QWERTYU", {status: [301, "Moved Permanently"], headers: {Location: "https://imgur.com/QWERTYU"}}],
            [:get, "http://imgur.com/QWERTYU", {status: [301, "Moved Permanently"], headers: {Location: "https://imgur.com/QWERTYU"}}],
            [:head, "https://imgur.com/QWERTYU", {headers: {"Content-Type"=>"text/html"}}],
            [:get, "https://imgur.com/QWERTYU", {body: <<~HEREDOC
              <html>
                <head>
                  <meta property="og:url" data-react-helmet="true" content="https://imgur.com/QWERTYU">
                  <meta name="twitter:image" data-react-helmet="true" content="https://i.imgur.com/QWERTYUh.jpg">
                  <meta property="og:image:width" data-react-helmet="true" content="1">
                  <meta property="og:image:height" data-react-helmet="true" content="2">
                  <meta property="og:image" data-react-helmet="true" content="https://i.imgur.com/QWERTYU.jpeg?fb">
                  <meta property="og:type" data-react-helmet="true" content="article">
                </head>
                <body></body>
              </html>
              HEREDOC
            } ],
            [:head, "https://i.imgur.com/QWERTYU.jpeg?fb"],
            [:get, "https://i.imgur.com/QWERTYU.jpeg?fb", {body: "\xFF\xD8\xFF\xE0\x00\x10JFIF\x00\x01\x01\x01\x00H\x00H\x00\x00\xFF\xDB\x00C\x00\x03\x02\x02\x02\x02\x02\x03\x02\x02\x02\x03\x03\x03\x03\x04\x06\x04\x04\x04\x04\x04\b\x06\x06\x05\x06\t\b\n\n\t\b\t\t\n\f\x0F\f\n\v\x0E\v\t\t\r\x11\r\x0E\x0F\x10\x10\x11\x10\n\f\x12\x13\x12\x10\x13\x0F\x10\x10\x10\xFF\xC9\x00\v\b\x00\x01\x00\x01\x01\x01\x11\x00\xFF\xCC\x00\x06\x00\x10\x10\x05\xFF\xDA\x00\b\x01\x01\x00\x00?\x00\xD2\xCF \xFF\xD9"}],
          ],
        ],
        [
          ["https://www.deviantart.com/nakilon/art/Nakilon-123456789", FastImage::UnknownImageType, true],
          [
            [:get, "https://www.deviantart.com/nakilon/art/Nakilon-123456789", {body: <<~HEREDOC
              <html>
                <head>
                  <meta data-rh="true" property="og:image" content="https://images-wixmp-abc456.wixmp.com/f/abc456-abc456/abc456-abc456.jpg/v1/fill/w_1024,h_732,q_75,strp/nakilon.jpg?token=abCD01.abCD01.abCD01_abCD01_abCD01"/>
                </head>
                <body class="theme-dark">
                  <div id="root">
                    <main role="main" class="_1TdPo">
                      <div class="_3tEjH">
                        <div><img alt="Nakilon" aria-hidden="true" class="_1izoQ" src="https://images-wixmp-abc456.wixmp.com/f/abc456-abc456/abc456-abc456.jpg/v1/fill/w_1024,h_732,q_75,strp/nakilon.jpg?token=abCD01.abCD01.abCD01_abCD01_abCD01"/></div>
                      </div>
                    </main>
                  </div>
                </body>
              </html>
              HEREDOC
            } ],
          ],
        ],
        [
          ["https://www.deviantart.com/nakilon/art/Nakilon-123456789", "https://images-wixmp-abc456.wixmp.com/f/abc456-abc456/abc456-abc456.jpg/v1/fill/w_1024,h_732,q_75,strp/nakilon.jpg?token=abCD01.abCD01.abCD01_abCD01_abCD01"],
          [
            [:head, "https://www.deviantart.com/nakilon/art/Nakilon-123456789", {headers: {"Content-Type"=>"text/html; charset=utf-8"}}],
            [:get, "https://www.deviantart.com/nakilon/art/Nakilon-123456789", {body: <<~HEREDOC
              <html>
                <head>
                  <meta data-rh="true" property="og:image" content="https://images-wixmp-abc456.wixmp.com/f/abc456-abc456/abc456-abc456.jpg/v1/fill/w_1024,h_732,q_75,strp/nakilon.jpg?token=abCD01.abCD01.abCD01_abCD01_abCD01"/>
                </head>
                <body class="theme-dark">
                  <div id="root">
                    <main role="main" class="_1TdPo">
                      <div class="_3tEjH">
                        <div><img alt="Nakilon" aria-hidden="true" class="_1izoQ" src="https://images-wixmp-abc456.wixmp.com/f/abc456-abc456/abc456-abc456.jpg/v1/fill/w_1024,h_732,q_75,strp/nakilon.jpg?token=abCD01.abCD01.abCD01_abCD01_abCD01"/></div>
                      </div>
                    </main>
                  </div>
                </body>
              </html>
              HEREDOC
            } ],
            [:head, "https://images-wixmp-abc456.wixmp.com/f/abc456-abc456/abc456-abc456.jpg/v1/fill/w_1024,h_732,q_75,strp/nakilon.jpg?token=abCD01.abCD01.abCD01_abCD01_abCD01"],
            [:get, "https://images-wixmp-abc456.wixmp.com/f/abc456-abc456/abc456-abc456.jpg/v1/fill/w_1024,h_732,q_75,strp/nakilon.jpg?token=abCD01.abCD01.abCD01_abCD01_abCD01", {body: "\xFF\xD8\xFF\xE0\x00\x10JFIF\x00\x01\x01\x01\x00H\x00H\x00\x00\xFF\xDB\x00C\x00\x03\x02\x02\x02\x02\x02\x03\x02\x02\x02\x03\x03\x03\x03\x04\x06\x04\x04\x04\x04\x04\b\x06\x06\x05\x06\t\b\n\n\t\b\t\t\n\f\x0F\f\n\v\x0E\v\t\t\r\x11\r\x0E\x0F\x10\x10\x11\x10\n\f\x12\x13\x12\x10\x13\x0F\x10\x10\x10\xFF\xC9\x00\v\b\x00\x01\x00\x01\x01\x01\x11\x00\xFF\xCC\x00\x06\x00\x10\x10\x05\xFF\xDA\x00\b\x01\x01\x00\x00?\x00\xD2\xCF \xFF\xD9"}],
          ],
        ],
        # TODO: og:image without scheme
        [
          ["https://www.reddit.com/r/darksouls3/comments/qwe123/hand/", DirectLink::ErrorBadLink, true],
          [
            [:head, "https://www.reddit.com/qwe123.json", {status: [301, "Moved Permanently"], headers: {location: "https://www.reddit.com/r/darksouls3/comments/qwe123/hand/.json"}}],
            [:head, "https://www.reddit.com/r/darksouls3/comments/qwe123/hand/.json"],
            [:get, "https://www.reddit.com/qwe123.json", {status: [301, "Moved Permanently"], headers: {"Location"=>"https://www.reddit.com/r/darksouls3/comments/qwe123/hand/.json"}}],
            [:get, "https://www.reddit.com/r/darksouls3/comments/qwe123/hand/.json", {body: <<~HEREDOC
              [
                 {
                    "data" : {
                       "before" : null,
                       "children" : [
                          {
                             "data" : {
                                "selftext" : "[A](https://imgur.com/a/abcDEF1). I \\n [Here](https://imgur.com/a/abcDEF2)\\n\\nMobile: https://imgur.com/a/abcDEF3",
                                "id" : "qwe123",
                                "name" : "t3_qwe123",
                                "is_self" : true,
                                "media" : null,
                                "permalink" : "/r/darksouls3/comments/qwe123/hand/",
                                "over_18" : false,
                                "url" : "https://www.reddit.com/r/darksouls3/comments/qwe123/hand/"
                             },
                             "kind" : "t3"
                          }
                       ]
                    }
                 }, {}
              ]
              HEREDOC
            } ],
          ],
        ],
        [
          ["https://www.reddit.com/r/darksouls3/comments/qwe123/hand/", 6],   # TODO: should see the 3rd album too
          [
            [:head, "https://www.reddit.com/qwe123.json", {status: [301, "Moved Permanently"], headers: {location: "https://www.reddit.com/r/darksouls3/comments/qwe123/hand/.json"}}],
            [:head, "https://www.reddit.com/r/darksouls3/comments/qwe123/hand/.json"],
            [:get, "https://www.reddit.com/qwe123.json", {status: [301, "Moved Permanently"], headers: {Location: "https://www.reddit.com/r/darksouls3/comments/qwe123/hand/.json"}}],
            [:get, "https://www.reddit.com/r/darksouls3/comments/qwe123/hand/.json", {body: <<~HEREDOC
              [
                 {
                    "data" : {
                       "before" : null,
                       "children" : [
                          {
                             "data" : {
                                "selftext" : "[A](https://imgur.com/a/abcDEF1). I \\n [Here](https://imgur.com/a/abcDEF2)\\n\\nMobile: https://imgur.com/a/abcDEF3",
                                "id" : "qwe123",
                                "name" : "t3_qwe123",
                                "is_self" : true,
                                "media" : null,
                                "permalink" : "/r/darksouls3/comments/qwe123/hand/",
                                "over_18" : false,
                                "url" : "https://www.reddit.com/r/darksouls3/comments/qwe123/hand/"
                             },
                             "kind" : "t3"
                          }
                       ]
                    }
                 }, {}
              ]
              HEREDOC
            } ],
            [:head, "https://imgur.com/a/abcDEF1"],
            [:head, "https://api.imgur.com/3/album/abcDEF1/0.json"],
            [:get, "https://api.imgur.com/3/album/abcDEF1/0.json", {body: <<~HEREDOC
              {
                 "status" : 200,
                 "success" : true,
                 "data" : {
                    "id" : "abcDEF1",
                    "link" : "https://imgur.com/a/abcDEF1",
                    "images" : [
                       {
                          "link" : "https://i.imgur.com/abcDEF4.png",
                          "type" : "image/png",
                          "height" : 1080,
                          "width" : 1920
                       },
                       {
                          "link" : "https://i.imgur.com/abcDEF5.png",
                          "type" : "image/png",
                          "height" : 1080,
                          "width" : 1920
                       }
                    ]
                 }
              }
              HEREDOC
            } ],
            [:head, "https://imgur.com/a/abcDEF2"],
            [:head, "https://api.imgur.com/3/album/abcDEF2/0.json"],
            [:get, "https://api.imgur.com/3/album/abcDEF2/0.json", {body: <<~HEREDOC
              {
                 "status" : 200,
                 "success" : true,
                 "data" : {
                    "id" : "abcDEF2",
                    "link" : "https://imgur.com/a/abcDEF2",
                    "images" : [
                       {
                          "link" : "https://i.imgur.com/abcDEF6.png",
                          "type" : "image/png",
                          "height" : 1080,
                          "width" : 1920
                       },
                       {
                          "link" : "https://i.imgur.com/abcDEF7.jpg",
                          "type" : "image/jpeg",
                          "height" : 1080,
                          "width" : 1920
                       },
                       {
                          "link" : "https://i.imgur.com/abcDEF8.jpg",
                          "type" : "image/jpeg",
                          "height" : 1080,
                          "width" : 1920
                       },
                       {
                          "link" : "https://i.imgur.com/abcDEF9.jpg",
                          "type" : "image/jpeg",
                          "height" : 1080,
                          "width" : 1920
                       }
                    ]
                 }
              }
              HEREDOC
            } ],
          ],
        ],
      ].each do |(input, expectation, giveup), stubs|
        it "#{URI(input).host} giveup=#{!!giveup}" do
          stub_request(:head, input)
          stubs.each do |mtd, link, response|
            if response
              stub_request(mtd, link).to_return **response
            else
              stub_request(mtd, link)
            end
          end
          ti = ENV.delete "IMGUR_CLIENT_ID" if %w{ imgur com } == URI(input).host.split(?.).last(2)
          tr = ENV.delete "REDDIT_SECRETS" if %w{ reddit com } == URI(input).host.split(?.).last(2)
          begin
            case expectation
            when Class
              e = assert_raises expectation, "for #{input} (giveup = #{giveup})" do
                DirectLink input, 5, giveup: giveup
              end
              assert_equal expectation.to_s, e.class.to_s, "for #{input} (giveup = #{giveup})"
            when String
              result = DirectLink input, 5, giveup: giveup
              assert_equal expectation, result.url, "for #{input} (giveup = #{giveup})"
            else
              result = DirectLink input, 5, giveup: giveup
              result = [result] unless result.is_a? Array   # we can't do `Array(<Struct>)` because it splats by elements
              assert_equal expectation, result.size, ->{
                "for #{input} (giveup = #{giveup}): #{result.map &:url}"
              }
            end
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

    popen = lambda do |input, stubs, export = nil, param = nil|
      file = Tempfile.new %w{ directlink_webmock .rb }
      file.write <<~HEREDOC
        require "webmock"
        include WebMock::API
        WebMock.enable!
        require "#{__dir__}/webmock_patch"
        #{stubs.inspect}.each do |mtd, input, response|
          if response
            stub_request(mtd, input).to_return **response
          else
            stub_request(mtd, input)
          end
        end
      HEREDOC
      file.flush
      begin
        Open3.capture2e "#{"export #{File.read("api_tokens.sh").scan(/(?<=^export )\S+=\S+/).join(" ")} && " if export}RUBYOPT='-r bundler/setup #{$-I.map{ |i| "-I #{i}" }.join " "} -r #{file.path}' ./bin/directlink#{" --#{param}" if param} #{input}"
      ensure
        file.close
        file.unlink
      end
    end

      [
        [1, "http://example.com/", /\AFastImage::UnknownImageType\n\z/, [
          [:head, "http://example.com/"],
          [:get, "http://example.com/", {body: "<html></html>"}],
        ] ],
        [1, "http://example.com/404", /\ANetHTTPUtils::Error: HTTP error #404 \n\z/, [
          [:head, "http://example.com/404", {status: [404, "Not Found"]}],
        ] ],

        # TODO: a test when the giveup=false fails and reraises the DirectLink::ErrorMissingEnvVar
        #       maybe put it to ./lib tests

        # by design it should be impossible to write a test for DirectLink::ErrorAssert
        [1, "https://flic.kr/p/DirectLinkErrorNotFound", /\ANetHTTPUtils::Error: HTTP error #404 \n\z/, [
          [:head, "https://flic.kr/p/DirectLinkErrorNotFound", {status: [302, "Found"], headers: {"Location"=>"https://www.flickr.com/photo.gne?short=DirectLinkErrorNotFound"}}],
          [:head, "https://www.flickr.com/photo.gne?short=DirectLinkErrorNotFound", {status: [302, "Found"], headers: {"Location"=>"/photo.gne?rb=1&short=DirectLinkErrorNotFound"}}],
          [:head, "https://www.flickr.com/photo.gne?rb=1&short=DirectLinkErrorNotFound", {status: [404, "Not Found"]}],
        ] ],

        [1, "https://imgur.com/a/badlinkpattern", /\ANetHTTPUtils::Error: HTTP error #404 \n\z/, [
          [:head, "https://imgur.com/a/badlinkpattern", {status: [404, "Not Found"]}],
        ] ],
        # TODO: a test that it appends the `exception.cause`
      ].each do |expected_exit_code, input, expected_output, stubs|
        it "fails" do
          string, status = popen.call(input, stubs, true)
          assert_equal expected_exit_code, status.exitstatus, "for #{input}"
          assert string[expected_output], "for #{input}: string=#{string.inspect}"
        end
      end

    valid_imgur_image_url1 = "https://goo.gl/ySqUb5"
    valid_imgur_image_url2 = "https://imgur.com/a/oacI3gl"
    stubs = [
      [:head, "https://goo.gl/ySqUb5", {status: [302, "Found"], headers: {"Location"=>"https://i.imgur.com/QpOBvRY.png"}}],
      [:head, "https://i.imgur.com/QpOBvRY.png"],
      [:head, "https://api.imgur.com/3/image/QpOBvRY/0.json"],
      [:get, "https://api.imgur.com/3/image/QpOBvRY/0.json", {body: <<~HEREDOC
        {
           "status" : 200,
           "success" : true,
           "data" : {
              "height" : 460,
              "link" : "https://i.imgur.com/QpOBvRY.png",
              "type" : "image/png",
              "width" : 460
           }
        }
        HEREDOC
      } ],
      [:head, "https://imgur.com/a/oacI3gl"],
      [:head, "https://api.imgur.com/3/album/oacI3gl/0.json"],
      [:get, "https://api.imgur.com/3/album/oacI3gl/0.json", {body: <<~HEREDOC
        {
           "status" : 200,
           "success" : true,
           "data" : {
              "id" : "oacI3gl",
              "link" : "https://imgur.com/a/oacI3gl",
              "images" : [
                 {
                    "height" : 100,
                    "link" : "https://i.imgur.com/9j4KdkJ.png",
                    "type" : "image/png",
                    "width" : 100
                 },
                 {
                    "height" : 460,
                    "link" : "https://i.imgur.com/QpOBvRY.png",
                    "type" : "image/png",
                    "width" : 460
                 }
              ]
           }
        }
        HEREDOC
      } ]
    ]
    [
      [stubs, <<~HEREDOC],
        <= #{valid_imgur_image_url1}
        => https://i.imgur.com/QpOBvRY.png
           image/png 460x460
        <= #{valid_imgur_image_url2}
        => https://i.imgur.com/QpOBvRY.png
           image/png 460x460
        => https://i.imgur.com/9j4KdkJ.png
           image/png 100x100
        HEREDOC
      [stubs, <<~HEREDOC, "json"]
        [
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
        HEREDOC
    ].each do |stubs, expected_output, param|
      it "#{param || "default"} output format" do
        string, status = popen.call("#{valid_imgur_image_url1} #{valid_imgur_image_url2}", stubs, true, param)
        assert_equal [0, expected_output], [status.exitstatus, string]
      end
    end

    it "reddit_bot gem logger does not flood STDOUT" do
      string, status = popen.call("http://redd.it/123abc", [
        [:head, "http://redd.it/123abc", {status: [301, "Moved Permanently"], headers: {"Location"=>"https://redd.it/123abc"}}],
        [:head, "https://redd.it/123abc", {status: [302, "Temporarily Moved"], headers: {"Location"=>"https://www.reddit.com/comments/123abc"}}],
        [:head, "https://www.reddit.com/comments/123abc"],
        [:post, "https://www.reddit.com/api/v1/access_token", {body: {"access_token": "123456789268-NxVk35tst8DttE5uCSD8pPY00XeAXQ"}.to_json}],
        [:get, "https://oauth.reddit.com/by_id/t3_123abc?api_type=json", {body: <<~HEREDOC
          {
             "data" : {
                "children" : [
                   {
                      "data" : {
                         "id" : "123abc",
                         "is_self" : true,
                         "media" : null,
                         "name" : "t3_123abc",
                         "permalink" : "/r/test___________/comments/123abc/for_the_httpsgithubcomnakilondirectlink_unit_tests/",
                         "selftext" : "https://i.imgur.com/ABCabcd.jpg [test](https://goo.gl/ySqUb5)",
                         "url" : "https://www.reddit.com/r/test___________/comments/123abc/for_the_httpsgithubcomnakilondirectlink_unit_tests/"
                      }
                   }
                ]
             }
          }
          HEREDOC
        } ],
        [:head, "https://goo.gl/ySqUb5", {status: [302, "Found"], headers: {"Location"=>"https://i.imgur.com/QpOBvRY.png"}}],
        [:head, "https://i.imgur.com/QpOBvRY.png"],
        [:head, "https://api.imgur.com/3/image/QpOBvRY/0.json"],
        [:get, "https://api.imgur.com/3/image/QpOBvRY/0.json", {body: <<~HEREDOC
          {
             "status" : 200,
             "success" : true,
             "data" : {
                "height" : 460,
                "width" : 460,
                "link" : "https://i.imgur.com/QpOBvRY.png",
                "type" : "image/png"
             }
          }
          HEREDOC
        } ],
      ] )
      assert_equal "<= http://redd.it/123abc\n=> https://i.imgur.com/QpOBvRY.png\n   image/png 460x460\n", string
    end

    # TODO: test about --json
    it "does not give up" do
      string, status = popen.call("https://www.kp.ru/daily/123/", [
        [:head, "https://www.kp.ru/daily/123/", {headers: {"Content-Type"=>"text/html"}}],
        [:get, "https://www.kp.ru/daily/123/", {body: <<~HEREDOC
          <!DOCTYPE html>
          <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
              <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
              <link rel="icon" type="image/png" href="/favicon-16.png" sizes="16x16" />
              <link rel="icon" type="image/png" href="/favicon-32.png" sizes="32x32" />
              <link rel="icon" type="image/png" href="/favicon-96.png" sizes="96x96" />
              <link rel="icon" type="image/png" href="/favicon-128.png" sizes="128x128" />
              <meta data-react-helmet="true" property="og:image" content="https://s11.stc.all.kpcdn.net/share/20.jpg" />
              <meta data-react-helmet="true" name="twitter:image:src" content="https://s11.stc.all.kpcdn.net/share/20.jpg" />
              <link data-react-helmet="true" rel="image_src" href="https://s11.stc.all.kpcdn.net/share/20.jpg" />
            </head>
            <body>
              <div id="app">
                <div>
                  <a href="/daily/author/1234">
                    <img alt="Александра" src="https://s14.stc.all.kpcdn.net/share/i/3/1234567/avatar.jpg" data-show-on-desktop="false" data-show-on-mobile="false" />
                    Ы
                  </a>
                </div>
              </div>
            </body>
          </html>
          HEREDOC
        } ],
        [:head, "https://s11.stc.all.kpcdn.net/share/20.jpg"],
        [:get, "https://s11.stc.all.kpcdn.net/share/20.jpg", {body: "\xFF\xD8\xFF\xE0\x00\x10JFIF\x00\x01\x01\x01\x00H\x00H\x00\x00\xFF\xDB\x00C\x00\x03\x02\x02\x02\x02\x02\x03\x02\x02\x02\x03\x03\x03\x03\x04\x06\x04\x04\x04\x04\x04\b\x06\x06\x05\x06\t\b\n\n\t\b\t\t\n\f\x0F\f\n\v\x0E\v\t\t\r\x11\r\x0E\x0F\x10\x10\x11\x10\n\f\x12\x13\x12\x10\x13\x0F\x10\x10\x10\xFF\xC9\x00\v\b\x00\x01\x00\x01\x01\x01\x11\x00\xFF\xCC\x00\x06\x00\x10\x10\x05\xFF\xDA\x00\b\x01\x01\x00\x00?\x00\xD2\xCF \xFF\xD9"}],
      ], false, "json")
      assert_equal [0, "https://s11.stc.all.kpcdn.net/share/20.jpg"], [status.exitstatus, JSON.load(string).fetch("url")]
    end

  end

end
