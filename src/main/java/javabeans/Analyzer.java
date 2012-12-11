/**
 * 
 */
package javabeans;

/**
 * @author damon
 * 
 */
public class Analyzer {
	// fields
	private int aid;
	private String name;
	private String description;

	public Analyzer() {

	}

	public Analyzer(int aid, String name, String description) {
		this.aid = aid;
		this.name = name;
		this.description = description;
	}

	public int getAId() {
		return this.aid;
	}
	
	public void setAId(int aid) {
		this.aid = aid;
	}
	
	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return this.name;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getDescription() {
		return this.description;
	}
}
