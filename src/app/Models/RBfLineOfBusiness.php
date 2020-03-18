<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class RBfLineOfBusiness
 * 
 * @property int $LINE_OF_BUSINESS_ID
 * @property string $LINE_OF_BUSINESS_NAME
 * 
 * @property \Illuminate\Database\Eloquent\Collection $t_bf_business_activities
 *
 * @package App\Models
 */
class RBfLineOfBusiness extends Eloquent
{
	protected $table = 'r_bf_line_of_business';
	protected $primaryKey = 'LINE_OF_BUSINESS_ID';
	public $timestamps = false;

	protected $fillable = [
		'LINE_OF_BUSINESS_NAME'
	];

	public function t_bf_business_activities()
	{
		return $this->hasMany(\App\Models\TBfBusinessActivity::class, 'LINE_OF_BUSINESS_ID');
	}
}
