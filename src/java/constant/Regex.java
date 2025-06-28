/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package constant;

/**
 *
 * @author CAU_TU
 */
public class Regex {

    public static String        NAME_REGEX                 = "^[A-Za-zÀ-Ỹà-ỹĂăÂâĐđÊêÔôƠơƯưÁáÀàẢảÃãẠạẮắẰằẲẳẴẵẶặẤấẦầẨẩẪẫẬậ"
                                                           + "ÉéÈèẺẻẼẽẸẹẾếỀềỂểỄễỆệÍíÌìỈỉĨĩỊịÓóÒòỎỏÕõỌọỐốỒồỔổỖỗỘộỚớỜờỞởỠỡỢợ"
                                                           + "ÚúÙùỦủŨũỤụỨứỪừỬửỮữỰựÝýỲỳỶỷỸỹỴỵ\\s]{2,50}$";
    public static String        EMAIL_REGEX                = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
}
