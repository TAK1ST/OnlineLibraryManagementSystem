/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author asus
 */
public class SystemConfig {
    private int id;
    private String configKey;
    private  float configValue;
    private String description;

      public SystemConfig() {
      }

      public SystemConfig(int id, String configKey, float configValue, String description) {
            this.id = id;
            this.configKey = configKey;
            this.configValue = configValue;
            this.description = description;
      }

      public int getId() {
            return id;
      }

      public void setId(int id) {
            this.id = id;
      }

      public String getConfigKey() {
            return configKey;
      }

      public void setConfigKey(String configKey) {
            this.configKey = configKey;
      }

      public float getConfigValue() {
            return configValue;
      }

      public void setConfigValue(float configValue) {
            this.configValue = configValue;
      }

      public String getDescription() {
            return description;
      }

      public void setDescription(String description) {
            this.description = description;
      }
    
}
