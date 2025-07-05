/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.interfaces;

import entity.User;
import java.util.List;
/**
 *
 * @author asus
 */
public interface IUserDAO extends IBaseDAO<User> {

    public int insertNewUser(String name, String email, String password);
    
    public int getTotalUsers();
    
    public List<User> getAll();

    public List<User> getUserBySearch(String email, String name, int offset);
    
    public List<User> getUserLazyPageLoading(int offset);
    
    public User getUser(String email, String password);
            
    public User getId(int id);

    public User getName(String name);

    public User getEmail(String email);
    
    public void save(User user);
    
    public int updateUserProfile(int id, String name, String avatarPath);
    
    public void delete(int userId);
    
    public void testBCrypt(String plainPassword);
    
    public int updateUser(int userId, String username, String password, String status);
    
    public boolean verifyPassword(int userId, String plainPassword);
    
    public int updatePassword(int userId, String newPassword);
    
    public boolean saveResetToken(int userId, String token, long expirationTime) throws ClassNotFoundException;
    
    public boolean isValidToken(String token) throws ClassNotFoundException;
    
    public User getUserByToken(String token) throws ClassNotFoundException;
    
    public void deleteToken(String token) throws ClassNotFoundException;
    
    public User getUserByEmail(String email) throws ClassNotFoundException;
}
