//
//  EBSecondViewController.m
//  MiCongreso
//
//  Created by Edu on 16/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import "EBSecondViewController.h"

@interface EBSecondViewController ()

@end

@implementation EBSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    senadores = [[NSMutableDictionary alloc]init];
    senadoresFiltradosDic = [[NSMutableDictionary alloc]init];
    [self descargarSenadores];
    self.navigationItem.title = @"Congresistas";

    segmented =  [[[[self.childViewControllers objectAtIndex:0]view]subviews]objectAtIndex:0];
    
    [segmented addTarget:self action:@selector(filtrar)
               forControlEvents:UIControlEventValueChanged];
 
}

-(void)filtrar{
    [senadoresFiltradosDic removeAllObjects];
    //NSLog(@"Changed to %d", segmented.selectedSegmentIndex);
    
    NSArray *partidos = @[@"PRI", @"PAN", @"PRD", @"PVEM", @"NA", @"PT", @"MC"];
    NSString *partido = [partidos objectAtIndex:segmented.selectedSegmentIndex];
    
    
    NSArray *keys = [[senadores allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    int i;
    
    for (i=0; i<[keys count]; i++) {
        NSString *currentKey = [keys objectAtIndex:i];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for (EBCongresista *senador in [senadores objectForKey:currentKey]) {
            if ([senador.partido isEqualToString:partido]) {
                [temp addObject:senador];
            }
        }
        if (temp.count) {
            [senadoresFiltradosDic setObject:temp forKey:currentKey];
        }
    }
    //NSLog(@"Filtrados: %@", senadoresFiltradosDic);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)descargarDiputados{
    
    
}


-(void)descargarSenadores{
    char letra;
    
    for (letra = 'A'; letra<='Z'; letra++) {
        //NSLog(@"%c", letra);
        
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.senado.gob.mx/?ver=int&mn=9&sm=1&str=%c", letra]];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:URL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            if (data){
                TFHpple *parser = [TFHpple hppleWithHTMLData:data];
                NSString *queryString = @"//div[@id='contenido_interior']/table/tr/td/table/tr";
                NSArray *nodos = [parser searchWithXPathQuery:queryString];
                NSMutableArray *senadoresArray = [[NSMutableArray alloc]init];
                if ([nodos count]) {
                    for (TFHppleElement *elemento in nodos) {
                        EBCongresista *congresista = [[EBCongresista alloc]initWithElement:elemento];
                        [senadoresArray addObject:congresista];
                    }
                    NSLog(@"Array for %c is %@ count %d", letra, senadoresArray, senadoresArray.count);
                    if (senadoresArray.count) {
                        [senadores setObject:senadoresArray forKey:[NSString stringWithFormat:@"%c", letra]];

                    }
                    
                }
            }
            else if (error)
                NSLog(@"%@",error);
        }];
        
    }
    
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    // Configure the cell...
    NSString *key = [[[senadoresFiltradosDic allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]objectAtIndex:indexPath.section];
    
    
    cell.textLabel.text = [[[senadoresFiltradosDic objectForKey:key]objectAtIndex:indexPath.row]nombre];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[senadoresFiltradosDic allKeys]count];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[senadoresFiltradosDic allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [[senadoresFiltradosDic allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *keys = [[senadoresFiltradosDic allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    return [[senadoresFiltradosDic objectForKey:[keys objectAtIndex:section]]count];
}




@end
